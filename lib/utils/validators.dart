/// Form doğrulama yardımcı fonksiyonları
class Validators {
  Validators._();

  /// E-posta doğrulama
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi zorunludur';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }

  /// Şifre doğrulama
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre zorunludur';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }

  /// Şifre tekrar doğrulama
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Şifre tekrarı zorunludur';
    }
    if (value != password) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }

  /// İsim doğrulama
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'İsim zorunludur';
    }
    if (value.length < 2) {
      return 'İsim en az 2 karakter olmalıdır';
    }
    return null;
  }

  /// Telefon numarası doğrulama
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Opsiyonel alan
    }
    final phoneRegex = RegExp(r'^[0-9]{10,11}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Geçerli bir telefon numarası girin';
    }
    return null;
  }

  /// Adres doğrulama
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Adres zorunludur';
    }
    if (value.length < 10) {
      return 'Lütfen tam adresinizi girin';
    }
    return null;
  }
}
