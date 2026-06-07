import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/pizza_model.dart';
import '../models/cart_item_model.dart';

/// Sepet yönetimini sağlayan Provider
/// Ürün ekleme, çıkarma, adet güncelleme ve toplam fiyat hesaplama
class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  static const double _deliveryFee = 14.90;
  static const double _freeDeliveryThreshold = 150.0;

  // Getter'lar
  List<CartItemModel> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  /// Toplam ürün adedi
  int get totalQuantity =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  /// Ara toplam (teslimat ücreti hariç)
  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Teslimat ücreti (belirli tutarın üzeri ücretsiz)
  double get deliveryFee =>
      subtotal >= _freeDeliveryThreshold ? 0.0 : _deliveryFee;

  /// Genel toplam
  double get total => subtotal + deliveryFee;

  /// Ücretsiz teslimat için kalan tutar
  double get remainingForFreeDelivery =>
      subtotal >= _freeDeliveryThreshold
          ? 0.0
          : _freeDeliveryThreshold - subtotal;

  /// Sepete ürün ekler
  void addItem({
    required PizzaModel pizza,
    required String size,
    int quantity = 1,
    List<String> extras = const [],
  }) {
    // Aynı pizza ve boyut varsa adeti artır
    final existingIndex = _items.indexWhere(
      (item) =>
          item.pizza.id == pizza.id &&
          item.selectedSize == size &&
          _listEquals(item.extraIngredients, extras),
    );

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItemModel(
        id: const Uuid().v4(),
        pizza: pizza,
        selectedSize: size,
        quantity: quantity,
        extraIngredients: extras,
      ));
    }
    notifyListeners();
  }

  /// Sepetten ürün kaldırır
  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  /// Ürün adedini günceller
  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  /// Ürün adedini 1 artırır
  void incrementQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// Ürün adedini 1 azaltır
  void decrementQuantity(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Sepeti temizler
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// İki listenin eşit olup olmadığını kontrol eder
  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
