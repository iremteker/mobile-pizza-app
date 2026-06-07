import 'pizza_model.dart';

/// Sepet öğesi modeli
/// Bir pizza ürünü, seçilen boyut ve adet bilgisini içerir
class CartItemModel {
  final String id;
  final PizzaModel pizza;
  final String selectedSize;
  int quantity;
  final List<String> extraIngredients;

  CartItemModel({
    required this.id,
    required this.pizza,
    required this.selectedSize,
    this.quantity = 1,
    this.extraIngredients = const [],
  });

  /// Toplam fiyat hesaplama (boyut + ekstra malzemeler)
  double get totalPrice {
    double price = pizza.getPriceBySize(selectedSize);
    // Her ekstra malzeme 5₺
    price += extraIngredients.length * 5.0;
    return price * quantity;
  }

  /// Birim fiyat (adet çarpılmadan)
  double get unitPrice {
    double price = pizza.getPriceBySize(selectedSize);
    price += extraIngredients.length * 5.0;
    return price;
  }

  /// Firestore dökümanından oluşturma
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] ?? '',
      pizza: PizzaModel.fromMap(map['pizza'] ?? {}),
      selectedSize: map['selectedSize'] ?? 'Orta',
      quantity: map['quantity'] ?? 1,
      extraIngredients: List<String>.from(map['extraIngredients'] ?? []),
    );
  }

  /// Firestore dökümanına dönüştürme
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pizza': pizza.toMap(),
      'selectedSize': selectedSize,
      'quantity': quantity,
      'extraIngredients': extraIngredients,
    };
  }

  @override
  String toString() =>
      'CartItem(${pizza.name}, $selectedSize, x$quantity, ${totalPrice}₺)';
}
