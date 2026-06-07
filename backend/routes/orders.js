const express = require('express');
const { body, validationResult } = require('express-validator');
const { pool } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

function parseOrder(row, items) {
  return {
    id: String(row.id),
    userId: row.user_id,
    subtotal: parseFloat(row.subtotal),
    deliveryFee: parseFloat(row.delivery_fee),
    total: parseFloat(row.total),
    status: row.status,
    deliveryAddress: row.delivery_address,
    note: row.note || null,
    createdAt: row.created_at ? new Date(row.created_at).toISOString() : new Date().toISOString(),
    items: items.map((item) => ({
      id: String(item.id),
      pizza: typeof item.pizza_data === 'string' ? JSON.parse(item.pizza_data) : item.pizza_data,
      selectedSize: item.selected_size,
      quantity: parseInt(item.quantity),
      extraIngredients: typeof item.extra_ingredients === 'string'
        ? JSON.parse(item.extra_ingredients)
        : (item.extra_ingredients || []),
    })),
  };
}

// POST /api/orders — Yeni sipariş oluştur
router.post(
  '/',
  authMiddleware,
  [
    body('items').isArray({ min: 1 }).withMessage('Sipariş öğeleri zorunludur.'),
    body('subtotal').isFloat({ min: 0 }).withMessage('Geçersiz ara toplam.'),
    body('deliveryFee').isFloat({ min: 0 }).withMessage('Geçersiz teslimat ücreti.'),
    body('total').isFloat({ min: 0 }).withMessage('Geçersiz toplam.'),
    body('deliveryAddress').trim().notEmpty().withMessage('Teslimat adresi zorunludur.'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, message: errors.array()[0].msg });
    }

    const { items, subtotal, deliveryFee, total, deliveryAddress, note } = req.body;
    const userId = req.user.uid;

    const conn = await pool.getConnection();
    try {
      await conn.beginTransaction();

      const [orderResult] = await conn.query(
        'INSERT INTO orders (user_id, subtotal, delivery_fee, total, status, delivery_address, note) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [userId, subtotal, deliveryFee, total, 'preparing', deliveryAddress, note || null]
      );
      const orderId = orderResult.insertId;

      for (const item of items) {
        await conn.query(
          'INSERT INTO order_items (order_id, pizza_data, selected_size, quantity, extra_ingredients, unit_price, total_price) VALUES (?, ?, ?, ?, ?, ?, ?)',
          [
            orderId,
            JSON.stringify(item.pizza),
            item.selectedSize,
            item.quantity,
            JSON.stringify(item.extraIngredients || []),
            item.unitPrice || 0,
            item.totalPrice || 0,
          ]
        );
      }

      await conn.commit();

      return res.status(201).json({
        success: true,
        message: 'Sipariş başarıyla oluşturuldu.',
        data: { orderId: String(orderId) },
      });
    } catch (err) {
      await conn.rollback();
      console.error('Sipariş oluşturma hatası:', err);
      return res.status(500).json({ success: false, message: 'Sipariş oluşturulamadı.' });
    } finally {
      conn.release();
    }
  }
);

// GET /api/orders/user/:userId — Kullanıcının siparişleri
router.get('/user/:userId', authMiddleware, async (req, res) => {
  const { userId } = req.params;

  // Kullanıcı sadece kendi siparişlerine erişebilir
  if (req.user.uid !== userId) {
    return res.status(403).json({ success: false, message: 'Erişim reddedildi.' });
  }

  try {
    const [orders] = await pool.query(
      'SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC',
      [userId]
    );

    const result = [];
    for (const order of orders) {
      const [items] = await pool.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
      result.push(parseOrder(order, items));
    }

    return res.json({ success: true, data: result });
  } catch (err) {
    console.error('Siparişler alınırken hata:', err);
    return res.status(500).json({ success: false, message: 'Sunucu hatası.' });
  }
});

// GET /api/orders/:id — Belirli sipariş
router.get('/:id', authMiddleware, async (req, res) => {
  try {
    const [orders] = await pool.query('SELECT * FROM orders WHERE id = ?', [req.params.id]);
    if (orders.length === 0) {
      return res.status(404).json({ success: false, message: 'Sipariş bulunamadı.' });
    }
    const order = orders[0];
    if (req.user.uid !== order.user_id) {
      return res.status(403).json({ success: false, message: 'Erişim reddedildi.' });
    }
    const [items] = await pool.query('SELECT * FROM order_items WHERE order_id = ?', [order.id]);
    return res.json({ success: true, data: parseOrder(order, items) });
  } catch (err) {
    return res.status(500).json({ success: false, message: 'Sunucu hatası.' });
  }
});

module.exports = router;
