const express = require('express');
const { body, validationResult } = require('express-validator');
const { pool } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

// GET /api/users/profile — Profil bilgisi
router.get('/profile', authMiddleware, async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT uid, email, name, phone, address, photo_url, created_at FROM users WHERE uid = ?',
      [req.user.uid]
    );
    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Kullanıcı bulunamadı.' });
    }
    const u = rows[0];
    return res.json({
      success: true,
      data: {
        uid: u.uid,
        email: u.email,
        name: u.name,
        phone: u.phone || '',
        address: u.address || '',
        photoUrl: u.photo_url || null,
        createdAt: u.created_at ? new Date(u.created_at).toISOString() : new Date().toISOString(),
      },
    });
  } catch (err) {
    return res.status(500).json({ success: false, message: 'Sunucu hatası.' });
  }
});

// PUT /api/users/profile — Profil güncelle
router.put(
  '/profile',
  authMiddleware,
  [
    body('name').optional().trim().notEmpty().withMessage('Ad soyad boş olamaz.'),
    body('phone').optional().trim(),
    body('address').optional().trim(),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, message: errors.array()[0].msg });
    }

    const { name, phone, address } = req.body;
    const updates = [];
    const values = [];

    if (name !== undefined) { updates.push('name = ?'); values.push(name); }
    if (phone !== undefined) { updates.push('phone = ?'); values.push(phone); }
    if (address !== undefined) { updates.push('address = ?'); values.push(address); }

    if (updates.length === 0) {
      return res.status(400).json({ success: false, message: 'Güncellenecek alan bulunamadı.' });
    }

    values.push(req.user.uid);

    try {
      await pool.query(`UPDATE users SET ${updates.join(', ')} WHERE uid = ?`, values);
      const [rows] = await pool.query(
        'SELECT uid, email, name, phone, address, photo_url, created_at FROM users WHERE uid = ?',
        [req.user.uid]
      );
      const u = rows[0];
      return res.json({
        success: true,
        message: 'Profil güncellendi.',
        data: {
          uid: u.uid,
          email: u.email,
          name: u.name,
          phone: u.phone || '',
          address: u.address || '',
          photoUrl: u.photo_url || null,
          createdAt: u.created_at ? new Date(u.created_at).toISOString() : new Date().toISOString(),
        },
      });
    } catch (err) {
      console.error('Profil güncelleme hatası:', err);
      return res.status(500).json({ success: false, message: 'Sunucu hatası.' });
    }
  }
);

module.exports = router;
