const express = require('express');
const { pool } = require('../config/database');

const router = express.Router();

function parsePizza(row) {
  return {
    id: String(row.id),
    name: row.name,
    description: row.description,
    imageUrl: row.image_url,
    basePrice: parseFloat(row.base_price),
    category: row.category,
    ingredients: typeof row.ingredients === 'string' ? JSON.parse(row.ingredients) : (row.ingredients || []),
    isPopular: Boolean(row.is_popular),
    isVegetarian: Boolean(row.is_vegetarian),
    rating: parseFloat(row.rating),
    reviewCount: parseInt(row.review_count),
  };
}

// GET /api/pizzas — Tüm pizzalar
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM pizzas ORDER BY is_popular DESC, name ASC');
    return res.json({ success: true, data: rows.map(parsePizza) });
  } catch (err) {
    console.error('Pizzalar alınırken hata:', err);
    return res.status(500).json({ success: false, message: 'Sunucu hatası.' });
  }
});

// GET /api/pizzas/popular — Popüler pizzalar
router.get('/popular', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM pizzas WHERE is_popular = TRUE ORDER BY rating DESC');
    return res.json({ success: true, data: rows.map(parsePizza) });
  } catch (err) {
    return res.status(500).json({ success: false, message: 'Sunucu hatası.' });
  }
});

// GET /api/pizzas/category/:category — Kategoriye göre pizzalar
router.get('/category/:category', async (req, res) => {
  try {
    const { category } = req.params;
    const [rows] = await pool.query('SELECT * FROM pizzas WHERE category = ? ORDER BY name ASC', [category]);
    return res.json({ success: true, data: rows.map(parsePizza) });
  } catch (err) {
    return res.status(500).json({ success: false, message: 'Sunucu hatası.' });
  }
});

// GET /api/pizzas/search?q=... — Pizza arama
router.get('/search', async (req, res) => {
  try {
    const q = `%${req.query.q || ''}%`;
    const [rows] = await pool.query(
      'SELECT * FROM pizzas WHERE name LIKE ? OR description LIKE ? ORDER BY name ASC',
      [q, q]
    );
    return res.json({ success: true, data: rows.map(parsePizza) });
  } catch (err) {
    return res.status(500).json({ success: false, message: 'Sunucu hatası.' });
  }
});

// GET /api/pizzas/:id — Belirli pizza
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM pizzas WHERE id = ?', [req.params.id]);
    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Pizza bulunamadı.' });
    }
    return res.json({ success: true, data: parsePizza(rows[0]) });
  } catch (err) {
    return res.status(500).json({ success: false, message: 'Sunucu hatası.' });
  }
});

module.exports = router;
