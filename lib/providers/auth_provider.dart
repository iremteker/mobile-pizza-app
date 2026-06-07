import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Kimlik doğrulama durumunu yöneten Provider — JWT + MySQL backend
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel _user = UserModel.empty;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;

  UserModel get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;

  /// Uygulama açılışında token varsa kullanıcıyı yükler
  Future<void> checkAuthState() async {
    final loggedIn = await _authService.isLoggedIn();
    if (!loggedIn) return;

    final profile = await _authService.getCurrentUser();
    if (profile != null) {
      _user = profile;
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  /// Email ve şifre ile giriş yapar
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.signInWithEmail(email, password);
      _isLoggedIn = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Yeni kullanıcı kaydı oluşturur
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    String phone = '',
    String address = '',
  }) async {
    _setLoading(true);
    try {
      _user = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
        address: address,
      );
      _isLoggedIn = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Oturumu kapatır
  Future<void> signOut() async {
    await _authService.signOut();
    _user = UserModel.empty;
    _isLoggedIn = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Kullanıcı profilini günceller
  Future<bool> updateProfile({String? name, String? phone, String? address}) async {
    try {
      final updatedUser = _user.copyWith(name: name, phone: phone, address: address);
      final result = await _authService.updateUserProfile(updatedUser);
      _user = result;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Şifre sıfırlama — backend destekliyorsa; şimdilik başarı döndürür
  Future<bool> resetPassword(String email) async {
    // MySQL backend şifre sıfırlama için e-posta gönderme endpoint'i eklenebilir.
    // Şimdilik kullanıcıya bilgi verilir.
    return true;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
