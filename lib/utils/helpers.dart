import 'package:intl/intl.dart';

/// Yardımcı fonksiyonlar
class Helpers {
  Helpers._();

  /// Fiyatı formatlar (örn: 89,90 ₺)
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,##0.00', 'tr_TR');
    return '${formatter.format(price)} ₺';
  }

  /// Tarihi formatlar (örn: 16 Mayıs 2026, 14:30)
  static String formatDate(DateTime date) {
    final formatter = DateFormat('d MMMM yyyy, HH:mm', 'tr_TR');
    return formatter.format(date);
  }

  /// Kısa tarih formatı (örn: 16 May 2026)
  static String formatDateShort(DateTime date) {
    final formatter = DateFormat('d MMM yyyy', 'tr_TR');
    return formatter.format(date);
  }

  /// Yıldız derecelendirmesini metne çevirir
  static String ratingText(double rating) {
    if (rating >= 4.5) return 'Mükemmel';
    if (rating >= 4.0) return 'Çok İyi';
    if (rating >= 3.5) return 'İyi';
    if (rating >= 3.0) return 'Orta';
    return 'Düşük';
  }
}
