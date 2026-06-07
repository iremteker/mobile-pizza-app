import 'package:flutter_test/flutter_test.dart';
import 'package:pizza_app/models/user_model.dart';

void main() {
  group('Kullanıcı Modeli Testleri', () {
    test('Boş kullanıcı nesnesi doğru oluşturulmalı', () {
      final user = UserModel.empty;
      expect(user.isEmpty, true);
      expect(user.isNotEmpty, false);
      expect(user.uid, '');
      expect(user.email, '');
      expect(user.name, '');
    });

    test('Dolu kullanıcı nesnesi isEmpty=false döndürmeli', () {
      final user = UserModel(uid: 'abc', email: 'a@b.com', name: 'Ali');
      expect(user.isEmpty, false);
      expect(user.isNotEmpty, true);
    });

    test('fromMap tüm alanları doğru okur', () {
      final map = {
        'uid': 'user-123',
        'email': 'test@example.com',
        'name': 'Test Kullanıcı',
        'phone': '5551234567',
        'address': 'İstanbul, Kadıköy',
        'photoUrl': null,
        'createdAt': '2024-01-01T00:00:00.000Z',
      };
      final user = UserModel.fromMap(map);
      expect(user.uid, 'user-123');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test Kullanıcı');
      expect(user.phone, '5551234567');
      expect(user.address, 'İstanbul, Kadıköy');
    });

    test('fromMap eksik alanlar için varsayılan değerler kullanılmalı', () {
      final user = UserModel.fromMap({'uid': 'u1', 'email': 'e@e.com', 'name': 'A'});
      expect(user.phone, '');
      expect(user.address, '');
      expect(user.photoUrl, null);
    });

    test('toMap doğru Map üretmeli', () {
      final user = UserModel(
        uid: 'uid_1',
        email: 'ali@test.com',
        name: 'Ali Veli',
        phone: '5559876543',
        address: 'Ankara, Çankaya',
      );
      final map = user.toMap();
      expect(map['uid'], 'uid_1');
      expect(map['email'], 'ali@test.com');
      expect(map['name'], 'Ali Veli');
      expect(map['phone'], '5559876543');
    });

    test('copyWith kısmen güncelleme yapabilmeli', () {
      final user = UserModel(uid: 'u1', email: 'e@e.com', name: 'Ali', phone: '111');
      final updated = user.copyWith(name: 'Mehmet', address: 'İzmir');
      expect(updated.uid, 'u1');
      expect(updated.email, 'e@e.com');
      expect(updated.name, 'Mehmet');
      expect(updated.phone, '111');
      expect(updated.address, 'İzmir');
    });

    test('fromMap → toMap round-trip tutarlı olmalı', () {
      final original = UserModel(
        uid: 'uid_rt',
        email: 'rt@test.com',
        name: 'Round Trip',
        phone: '5550000000',
        address: 'Test Mah. No:1',
      );
      final restored = UserModel.fromMap(original.toMap());
      expect(restored.uid, original.uid);
      expect(restored.email, original.email);
      expect(restored.name, original.name);
      expect(restored.phone, original.phone);
      expect(restored.address, original.address);
    });
  });

  group('E-posta Doğrulama Testleri', () {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    test('Geçerli e-posta kabul edilmeli', () {
      expect(emailRegex.hasMatch('test@example.com'), true);
      expect(emailRegex.hasMatch('user.name@domain.org'), true);
    });

    test('Geçersiz e-posta reddedilmeli', () {
      expect(emailRegex.hasMatch('notanemail'), false);
      expect(emailRegex.hasMatch('@nodomain.com'), false);
      expect(emailRegex.hasMatch('noDomain@'), false);
    });
  });

  group('Şifre Doğrulama Testleri', () {
    bool isValidPassword(String p) => p.length >= 6;

    test('6 karakter ve üzeri şifre geçerli olmalı', () {
      expect(isValidPassword('123456'), true);
      expect(isValidPassword('securePassword!'), true);
    });

    test('5 karakter ve altı şifre geçersiz olmalı', () {
      expect(isValidPassword('12345'), false);
      expect(isValidPassword(''), false);
    });
  });
}
