import 'package:flutter_test/flutter_test.dart';
import 'package:pizza_app/models/pizza_model.dart';

void main() {
  late PizzaModel testPizza;

  setUp(() {
    testPizza = PizzaModel(
      id: 'test_1',
      name: 'Test Margherita',
      description: 'Test açıklama',
      imageUrl: 'https://example.com/pizza.jpg',
      basePrice: 100.0,
      category: 'Klasik',
      ingredients: ['Mozzarella', 'Domates Sosu', 'Fesleğen'],
      isPopular: true,
      isVegetarian: true,
      rating: 4.5,
      reviewCount: 100,
    );
  });

  group('Pizza Modeli Testleri', () {
    test('Pizza nesnesi doğru oluşturulmalı', () {
      expect(testPizza.id, 'test_1');
      expect(testPizza.name, 'Test Margherita');
      expect(testPizza.basePrice, 100.0);
      expect(testPizza.isPopular, true);
      expect(testPizza.isVegetarian, true);
      expect(testPizza.ingredients.length, 3);
    });

    test('Küçük boyut fiyatı taban fiyata eşit olmalı', () {
      expect(testPizza.getPriceBySize('Küçük'), 100.0);
    });

    test('Orta boyut fiyatı taban fiyatın 1.3 katı olmalı', () {
      expect(testPizza.getPriceBySize('Orta'), 130.0);
    });

    test('Büyük boyut fiyatı taban fiyatın 1.6 katı olmalı', () {
      expect(testPizza.getPriceBySize('Büyük'), 160.0);
    });

    test('Ekstra büyük fiyat taban fiyatın 2 katı olmalı', () {
      expect(testPizza.getPriceBySize('Ekstra Büyük'), 200.0);
    });

    test('Bilinmeyen boyut taban fiyat döndürmeli', () {
      expect(testPizza.getPriceBySize('Bilinmeyen'), 100.0);
    });
  });

  group('Serileştirme Testleri', () {
    test('toMap doğru veri döndürmeli', () {
      final map = testPizza.toMap();
      expect(map['id'], 'test_1');
      expect(map['name'], 'Test Margherita');
      expect(map['basePrice'], 100.0);
      expect(map['isPopular'], true);
      expect(map['isVegetarian'], true);
      expect(map['category'], 'Klasik');
      expect((map['ingredients'] as List).length, 3);
    });

    test('fromMap doğru nesne oluşturmalı', () {
      final map = testPizza.toMap();
      final restored = PizzaModel.fromMap(map);

      expect(restored.id, testPizza.id);
      expect(restored.name, testPizza.name);
      expect(restored.basePrice, testPizza.basePrice);
      expect(restored.isPopular, testPizza.isPopular);
      expect(restored.isVegetarian, testPizza.isVegetarian);
      expect(restored.ingredients.length, testPizza.ingredients.length);
    });

    test('fromMap eksik alanları varsayılan değerlerle doldurmalı', () {
      final pizza = PizzaModel.fromMap({});
      expect(pizza.id, '');
      expect(pizza.name, '');
      expect(pizza.basePrice, 0.0);
      expect(pizza.isPopular, false);
      expect(pizza.category, 'Klasik');
    });

    test('fromMap ile docId kullanılabilmeli', () {
      final pizza = PizzaModel.fromMap(
        {'name': 'Test'},
        docId: 'custom_id',
      );
      expect(pizza.id, 'custom_id');
    });

    test('fromMap snake_case alanlarını desteklemeli (API yanıtı)', () {
      final map = {
        'id': '5',
        'name': 'Test Pizza',
        'description': 'Test',
        'image_url': 'https://example.com/img.jpg',
        'base_price': 89.90,
        'category': 'Özel',
        'ingredients': ['Peynir'],
        'is_popular': 1,
        'is_vegetarian': 0,
        'rating': 4.2,
        'review_count': 50,
      };
      final pizza = PizzaModel.fromMap(map);
      expect(pizza.imageUrl, 'https://example.com/img.jpg');
      expect(pizza.basePrice, 89.90);
      expect(pizza.isPopular, true);
      expect(pizza.isVegetarian, false);
    });
  });
}
