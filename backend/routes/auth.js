const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const { body, validationResult } = require('express-validator');
const { pool } = require('../config/database');
const authMiddleware = require('../middleware/authMiddleware');

const router = express.Router();

// POST /api/auth/register — Yeni kullanıcı kaydı
router.post(
  '/register',
  [
    body('email').isEmail().withMessage('Geçersiz e-posta adresi.'),
    body('password').isLength({ min: 6 }).withMessage('Şifre en az 6 karakter olmalı.'),
    body('name').trim().notEmpty().withMessage('Ad soyad zorunludur.'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, message: errors.array()[0].msg });
    }

    const { email, password, name, phone = '', address = '' } = req.body;

    try {
      // E-posta zaten kayıtlı mı?
      const [existing] = await pool.query('SELECT uid FROM users WHERE email = ?', [email.toLowerCase()]);
      if (existing.length > 0) {
        return res.status(409).json({ success: false, message: 'Bu e-posta adresi zaten kullanımda.' });
      }

      const uid = uuidv4();
      const passwordHash = await bcrypt.hash(password, 12);

      await pool.query(
        'INSERT INTO users (uid, email, password_hash, name, phone, address) VALUES (?, ?, ?, ?, ?, ?)',
        [uid, email.toLowerCase(), passwordHash, name.trim(), phone.trim(), address.trim()]
      );

      const token = jwt.sign({ uid, email: email.toLowerCase() }, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRES_IN || '30d',
      });

      return res.status(201).json({
        success: true,
        message: 'Kayıt başarılı.',
        data: {
          token,
          user: { uid, email: email.toLowerCase(), name: name.trim(), phone: phone.trim(), address: address.trim(), photoUrl: null, createdAt: new Date().toISOString() },
        },
      });
    } catch (err) {
      console.error('Register hatası:', err);
      return res.status(500).json({ success: false, message: 'Sunucu hatası. Lütfen tekrar deneyin.' });
    }
  }
);

// POST /api/auth/login — Giriş yap
router.post(
  '/login',
  [
    body('email').isEmail().withMessage('Geçersiz e-posta adresi.'),
    body('password').notEmpty().withMessage('Şifre zorunludur.'),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, message: errors.array()[0].msg });
    }

    const { email, password } = req.body;

    try {
      const [rows] = await pool.query('SELECT * FROM users WHERE email = ?', [email.toLowerCase()]);
      if (rows.length === 0) {
        return res.status(401).json({ success: false, message: 'Bu e-posta adresine ait kullanıcı bulunamadı.' });
      }

      const user = rows[0];
      const isValid = await bcrypt.compare(password, user.password_hash);
      if (!isValid) {
        return res.status(401).json({ success: false, message: 'Hatalı şifre girdiniz.' });
      }

      const token = jwt.sign({ uid: user.uid, email: user.email }, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRES_IN || '30d',
      });

      return res.json({
        success: true,
        message: 'Giriş başarılı.',
        data: {
          token,
          user: {
            uid: user.uid,
            email: user.email,
            name: user.name,
            phone: user.phone || '',
            address: user.address || '',
            photoUrl: user.photo_url || null,
            createdAt: user.created_at ? new Date(user.created_at).toISOString() : new Date().toISOString(),
          },
        },
      });
    } catch (err) {
      console.error('Login hatası:', err);
      return res.status(500).json({ success: false, message: 'Sunucu hatası. Lütfen tekrar deneyin.' });
    }
  }
);

// GET /api/auth/me — Token ile kullanıcı bilgisi
router.get('/me', authMiddleware, async (req, res) => {
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
    console.error('Me hatası:', err);
    return res.status(500).json({ success: false, message: 'Sunucu hatası.' });
  }
});

module.exports = router;
