import 'package:flutter_test/flutter_test.dart';
import 'package:pizza_app/models/pizza_model.dart';
import 'package:pizza_app/models/cart_item_model.dart';
import 'package:pizza_app/models/order_model.dart';

void main() {
  final pizza = PizzaModel(
    id: '1',
    name: 'Margherita',
    description: 'Klasik pizza',
    imageUrl: '',
    basePrice: 100.0,
    category: 'Klasik',
    ingredients: ['Mozzarella'],
  );

  final cartItem = CartItemModel(
    id: 'ci_1',
    pizza: pizza,
    selectedSize: 'Orta',
    quantity: 2,
    extraIngredients: [],
  );

  group('OrderModel Testleri', () {
    test('OrderStatus.preparing metni Hazırlanıyor olmalı', () {
      final order = OrderModel(
        id: 'o1', userId: 'u1', items: [],
        subtotal: 100, deliveryFee: 14.90, total: 114.90,
        deliveryAddress: 'Test', status: OrderStatus.preparing,
      );
      expect(order.statusText, 'Hazırlanıyor');
    });

    test('OrderStatus.onTheWay metni Yolda olmalı', () {
      final order = OrderModel(
        id: 'o2', userId: 'u1', items: [],
        subtotal: 100, deliveryFee: 0, total: 100,
        deliveryAddress: 'Test', status: OrderStatus.onTheWay,
      );
      expect(order.statusText, 'Yolda');
    });

    test('OrderStatus.delivered metni Teslim Edildi olmalı', () {
      final order = OrderModel(
        id: 'o3', userId: 'u1', items: [],
        subtotal: 100, deliveryFee: 0, total: 100,
        deliveryAddress: 'Test', status: OrderStatus.delivered,
      );
      expect(order.statusText, 'Teslim Edildi');
    });

    test('OrderStatus.cancelled metni İptal Edildi olmalı', () {
      final order = OrderModel(
        id: 'o4', userId: 'u1', items: [],
        subtotal: 100, deliveryFee: 0, total: 100,
        deliveryAddress: 'Test', status: OrderStatus.cancelled,
      );
      expect(order.statusText, 'İptal Edildi');
    });

    test('fromMap → toMap round-trip tutarlı olmalı', () {
      final order = OrderModel(
        id: '42',
        userId: 'user-uuid-abc',
        items: [cartItem],
        subtotal: 260.0,
        deliveryFee: 0.0,
        total: 260.0,
        deliveryAddress: 'İstanbul, Beşiktaş',
        note: 'Zil çalışmıyor',
        status: OrderStatus.preparing,
      );
      final map = order.toMap();
      final restored = OrderModel.fromMap(map);

      expect(restored.id, '42');
      expect(restored.userId, 'user-uuid-abc');
      expect(restored.subtotal, 260.0);
      expect(restored.deliveryFee, 0.0);
      expect(restored.total, 260.0);
      expect(restored.deliveryAddress, 'İstanbul, Beşiktaş');
      expect(restored.note, 'Zil çalışmıyor');
      expect(restored.status, OrderStatus.preparing);
      expect(restored.items.length, 1);
    });

    test('fromMap API yanıtı (snake_case) formatını işlemeli', () {
      final map = {
        'id': '10',
        'userId': 'user-123',
        'items': [],
        'subtotal': 150.0,
        'delivery_fee': 14.90,
        'total': 164.90,
        'status': 'onTheWay',
        'delivery_address': 'Ankara, Kızılay',
        'createdAt': '2024-06-01T10:00:00.000Z',
      };
      final order = OrderModel.fromMap(map);
      expect(order.id, '10');
      expect(order.deliveryFee, 14.90);
      expect(order.status, OrderStatus.onTheWay);
      expect(order.deliveryAddress, 'Ankara, Kızılay');
    });

    test('Bilinmeyen status değeri preparing olarak yorumlanmalı', () {
      final map = {
        'id': '1', 'userId': 'u', 'items': [],
        'subtotal': 0, 'deliveryFee': 0, 'total': 0,
        'deliveryAddress': '',
        'status': 'unknownStatus',
      };
      final order = OrderModel.fromMap(map);
      expect(order.status, OrderStatus.preparing);
    });

    test('CartItemModel toplam fiyatı doğru hesaplamalı', () {
      // (100 * 1.3 + 0 extras) * 2 = 260
      expect(cartItem.totalPrice, 260.0);
    });

    test('CartItemModel birim fiyatı adet çarpmadan hesaplamalı', () {
      expect(cartItem.unitPrice, 130.0);
    });
  });
}
