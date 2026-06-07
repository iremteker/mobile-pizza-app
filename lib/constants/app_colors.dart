import 'package:flutter/material.dart';

/// Uygulama renk sabitleri
/// Modern, canlı ve pizza temalı renk paleti
class AppColors {
  AppColors._();

  // Ana renkler
  static const Color primaryRed = Color(0xFFE23744);
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color accentOrange = Color(0xFFFF6F00);
  static const Color accentYellow = Color(0xFFFFB300);

  // Arka plan renkleri
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color surfaceDark = Color(0xFF16213E);
  static const Color cardDark = Color(0xFF0F3460);

  // Metin renkleri
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFE0E0E0);

  // Durum renkleri
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Gradient renkleri
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE23744), Color(0xFFFF6F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFF6F00), Color(0xFFE23744)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gölge renkleri
  static Color shadowColor = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.3);
}
