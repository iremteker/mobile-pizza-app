import '../models/user_model.dart';
import 'api_service.dart';

/// Kimlik doğrulama servisi — JWT tabanlı MySQL backend
class AuthService {
  final ApiService _api = ApiService();

  // ── Oturum durumu ────────────────────────────────────────────────────────────

  Future<bool> isLoggedIn() => _api.hasToken();

  /// Token ile mevcut kullanıcı bilgisini çeker
  Future<UserModel?> getCurrentUser() async {
    try {
      final res = await _api.get('/auth/me');
      if (res.statusCode == 200 && res.data['success'] == true) {
        return UserModel.fromMap(res.data['data']);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ── Giriş / Kayıt ────────────────────────────────────────────────────────────

  /// Email ve şifre ile giriş
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final res = await _api.post('/auth/login', data: {'email': email.trim(), 'password': password});
      if (res.statusCode == 200 && res.data['success'] == true) {
        final token = res.data['data']['token'] as String;
        await _api.saveToken(token);
        return UserModel.fromMap(res.data['data']['user']);
      }
      throw res.data['message'] ?? 'Giriş başarısız.';
    } catch (e) {
      if (e is String) rethrow;
      rethrow;
    }
  }

  /// Yeni kullanıcı kaydı
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    String phone = '',
    String address = '',
  }) async {
    try {
      final res = await _api.post('/auth/register', data: {
        'email': email.trim(),
        'password': password,
        'name': name.trim(),
        'phone': phone.trim(),
        'address': address.trim(),
      });
      if (res.statusCode == 201 && res.data['success'] == true) {
        final token = res.data['data']['token'] as String;
        await _api.saveToken(token);
        return UserModel.fromMap(res.data['data']['user']);
      }
      throw res.data['message'] ?? 'Kayıt başarısız.';
    } catch (e) {
      if (e is String) rethrow;
      rethrow;
    }
  }

  /// Oturumu kapat
  Future<void> signOut() async {
    await _api.clearToken();
  }

  /// Profil güncelle
  Future<UserModel> updateUserProfile(UserModel user) async {
    try {
      final res = await _api.put('/users/profile', data: {
        'name': user.name,
        'phone': user.phone,
        'address': user.address,
      });
      if (res.statusCode == 200 && res.data['success'] == true) {
        return UserModel.fromMap(res.data['data']);
      }
      throw res.data['message'] ?? 'Güncelleme başarısız.';
    } catch (e) {
      if (e is String) rethrow;
      rethrow;
    }
  }
}
