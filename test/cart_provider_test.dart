import 'package:flutter_test/flutter_test.dart';
import 'package:pizza_app/models/pizza_model.dart';
import 'package:pizza_app/providers/cart_provider.dart';

/// Sepet Provider unit testleri
/// Sepete ekleme, çıkarma, adet güncelleme ve fiyat hesaplama testleri
void main() {
  late CartProvider cartProvider;
  late PizzaModel testPizza;
  late PizzaModel testPizza2;

  setUp(() {
    cartProvider = CartProvider();
    testPizza = PizzaModel(
      id: 'test_1',
      name: 'Test Margherita',
      description: 'Test açıklama',
      imageUrl: 'https://example.com/pizza.jpg',
      basePrice: 100.0,
      category: 'Klasik',
      ingredients: ['Mozzarella', 'Domates Sosu'],
      isPopular: true,
    );
    testPizza2 = PizzaModel(
      id: 'test_2',
      name: 'Test Pepperoni',
      description: 'Test açıklama 2',
      imageUrl: 'https://example.com/pizza2.jpg',
      basePrice: 120.0,
      category: 'Klasik',
      ingredients: ['Pepperoni', 'Mozzarella'],
    );
  });

  group('Sepete Ekleme Testleri', () {
    test('Boş sepete pizza eklenebilmeli', () {
      expect(cartProvider.isEmpty, true);
      cartProvider.addItem(pizza: testPizza, size: 'Orta');
      expect(cartProvider.itemCount, 1);
      expect(cartProvider.isEmpty, false);
    });

    test('Aynı pizza ve boyut eklendiğinde adet artmalı', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta');
      cartProvider.addItem(pizza: testPizza, size: 'Orta');
      expect(cartProvider.itemCount, 1);
      expect(cartProvider.items.first.quantity, 2);
    });

    test('Farklı boyut seçildiğinde yeni ürün olarak eklenmeli', () {
      cartProvider.addItem(pizza: testPizza, size: 'Küçük');
      cartProvider.addItem(pizza: testPizza, size: 'Büyük');
      expect(cartProvider.itemCount, 2);
    });

    test('Farklı pizza eklendiğinde ayrı öğe olarak eklenmeli', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta');
      cartProvider.addItem(pizza: testPizza2, size: 'Orta');
      expect(cartProvider.itemCount, 2);
    });
  });

  group('Sepetten Çıkarma Testleri', () {
    test('Ürün sepetten kaldırılabilmeli', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta');
      final itemId = cartProvider.items.first.id;
      cartProvider.removeItem(itemId);
      expect(cartProvider.isEmpty, true);
    });

    test('Sepet temizleme tüm ürünleri kaldırmalı', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta');
      cartProvider.addItem(pizza: testPizza2, size: 'Büyük');
      expect(cartProvider.itemCount, 2);
      cartProvider.clearCart();
      expect(cartProvider.isEmpty, true);
    });
  });

  group('Adet Güncelleme Testleri', () {
    test('Adet artırılabilmeli', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta');
      final itemId = cartProvider.items.first.id;
      cartProvider.incrementQuantity(itemId);
      expect(cartProvider.items.first.quantity, 2);
    });

    test('Adet azaltılabilmeli', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta', quantity: 3);
      final itemId = cartProvider.items.first.id;
      cartProvider.decrementQuantity(itemId);
      expect(cartProvider.items.first.quantity, 2);
    });

    test('Adet 1 iken azaltılırsa ürün kaldırılmalı', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta');
      final itemId = cartProvider.items.first.id;
      cartProvider.decrementQuantity(itemId);
      expect(cartProvider.isEmpty, true);
    });

    test('Adet 0 olarak güncellenirse ürün kaldırılmalı', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta');
      final itemId = cartProvider.items.first.id;
      cartProvider.updateQuantity(itemId, 0);
      expect(cartProvider.isEmpty, true);
    });
  });

  group('Fiyat Hesaplama Testleri', () {
    test('Ara toplam doğru hesaplanmalı', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta'); // 100 * 1.3 = 130
      expect(cartProvider.subtotal, 130.0);
    });

    test('Birden fazla ürün ile ara toplam doğru olmalı', () {
      cartProvider.addItem(pizza: testPizza, size: 'Küçük'); // 100
      cartProvider.addItem(pizza: testPizza2, size: 'Küçük'); // 120
      expect(cartProvider.subtotal, 220.0);
    });

    test('Teslimat ücreti 150₺ altında uygulanmalı', () {
      cartProvider.addItem(pizza: testPizza, size: 'Küçük'); // 100₺
      expect(cartProvider.deliveryFee, 14.90);
    });

    test('150₺ üzeri ücretsiz teslimat olmalı', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta'); // 130₺
      cartProvider.addItem(pizza: testPizza2, size: 'Küçük'); // 120₺
      // Toplam: 250₺
      expect(cartProvider.deliveryFee, 0.0);
    });

    test('Toplam ürün adedi doğru hesaplanmalı', () {
      cartProvider.addItem(pizza: testPizza, size: 'Orta', quantity: 2);
      cartProvider.addItem(pizza: testPizza2, size: 'Büyük', quantity: 3);
      expect(cartProvider.totalQuantity, 5);
    });
  });
}
