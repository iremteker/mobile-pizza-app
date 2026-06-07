import 'package:flutter_test/flutter_test.dart';
import 'package:pizza_app/models/pizza_model.dart';
import 'package:pizza_app/models/cart_item_model.dart';
import 'package:pizza_app/models/order_model.dart';
import 'package:pizza_app/models/user_model.dart';

/// Sipariş ve kullanıcı modeli testleri
void main() {
  group('Sipariş Modeli Testleri', () {
    test('Sipariş durumu Türkçe metin döndürmeli', () {
      final order = OrderModel(
        id: 'order_1',
        userId: 'user_1',
        items: [],
        subtotal: 130.0,
        deliveryFee: 14.90,
        total: 144.90,
        deliveryAddress: 'Test adres',
        status: OrderStatus.preparing,
      );
      expect(order.statusText, 'Hazırlanıyor');
    });

    test('Yolda durumu doğru metni döndürmeli', () {
      final order = OrderModel(
        id: 'order_2',
        userId: 'user_1',
        items: [],
        subtotal: 200.0,
        deliveryFee: 0.0,
        total: 200.0,
        deliveryAddress: 'Test adres',
        status: OrderStatus.onTheWay,
      );
      expect(order.statusText, 'Yolda');
    });

    test('Teslim edildi durumu doğru metni döndürmeli', () {
      final order = OrderModel(
        id: 'order_3',
        userId: 'user_1',
        items: [],
        subtotal: 300.0,
        deliveryFee: 0.0,
        total: 300.0,
        deliveryAddress: 'Test adres',
        status: OrderStatus.delivered,
      );
      expect(order.statusText, 'Teslim Edildi');
    });

    test('Sipariş serileştirme ve deserializasyon doğru çalışmalı', () {
      final order = OrderModel(
        id: 'order_test',
        userId: 'user_test',
        items: [],
        subtotal: 150.0,
        deliveryFee: 0.0,
        total: 150.0,
        deliveryAddress: 'İstanbul, Kadıköy',
        note: 'Kapıya bırakın',
        status: OrderStatus.preparing,
      );

      final map = order.toMap();
      final restored = OrderModel.fromMap(map);

      expect(restored.userId, 'user_test');
      expect(restored.subtotal, 150.0);
      expect(restored.deliveryAddress, 'İstanbul, Kadıköy');
      expect(restored.note, 'Kapıya bırakın');
      expect(restored.status, OrderStatus.preparing);
    });
  });

  group('Kullanıcı Modeli Testleri', () {
    test('Boş kullanıcı doğru oluşturulmalı', () {
      final user = UserModel.empty;
      expect(user.isEmpty, true);
      expect(user.isNotEmpty, false);
      expect(user.uid, '');
    });

    test('Kullanıcı kopyalama (copyWith) doğru çalışmalı', () {
      final user = UserModel(
        uid: 'uid_1',
        email: 'test@test.com',
        name: 'Test User',
      );

      final updated = user.copyWith(name: 'Updated User', phone: '5551234567');

      expect(updated.uid, 'uid_1');
      expect(updated.email, 'test@test.com');
      expect(updated.name, 'Updated User');
      expect(updated.phone, '5551234567');
    });

    test('Kullanıcı serileştirme doğru çalışmalı', () {
      final user = UserModel(
        uid: 'uid_test',
        email: 'test@example.com',
        name: 'Test Kullanıcı',
        phone: '5551234567',
        address: 'Test adres',
      );

      final map = user.toMap();
      final restored = UserModel.fromMap(map);

      expect(restored.uid, user.uid);
      expect(restored.email, user.email);
      expect(restored.name, user.name);
      expect(restored.phone, user.phone);
    });
  });

  group('Sepet Öğesi Modeli Testleri', () {
    test('Toplam fiyat doğru hesaplanmalı', () {
      final pizza = PizzaModel(
        id: '1',
        name: 'Test',
        description: 'Test',
        imageUrl: '',
        basePrice: 100.0,
        category: 'Klasik',
        ingredients: [],
      );

      final cartItem = CartItemModel(
        id: 'cart_1',
        pizza: pizza,
        selectedSize: 'Orta', // 100 * 1.3 = 130
        quantity: 2,
        extraIngredients: ['Ekstra Peynir'], // +5
      );

      // (130 + 5) * 2 = 270
      expect(cartItem.totalPrice, 270.0);
    });

    test('Birim fiyat adet çarpılmadan hesaplanmalı', () {
      final pizza = PizzaModel(
        id: '1',
        name: 'Test',
        description: 'Test',
        imageUrl: '',
        basePrice: 100.0,
        category: 'Klasik',
        ingredients: [],
      );

      final cartItem = CartItemModel(
        id: 'cart_1',
        pizza: pizza,
        selectedSize: 'Büyük', // 100 * 1.6 = 160
        quantity: 3,
        extraIngredients: ['Mantar', 'Mısır'], // +10
      );

      expect(cartItem.unitPrice, 170.0);
      expect(cartItem.totalPrice, 510.0);
    });
  });
}
