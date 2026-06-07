import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../services/order_service.dart';

/// Sipariş yönetimini sağlayan Provider
class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<OrderModel> _orders = [];
  bool _isLoading = false;
  OrderModel? _lastOrder;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  OrderModel? get lastOrder => _lastOrder;

  Future<bool> createOrder({
    required String userId,
    required List<CartItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String deliveryAddress,
    String? note,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final orderId = await _orderService.createOrder(
        userId: userId,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        deliveryAddress: deliveryAddress,
        note: note,
      );

      _lastOrder = OrderModel(
        id: orderId,
        userId: userId,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        deliveryAddress: deliveryAddress,
        note: note,
        status: OrderStatus.preparing,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Sipariş oluşturma hatası: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadOrders(String userId) async {
    _isLoading = true;
    notifyListeners();

    _orders = await _orderService.getUserOrders(userId);

    _isLoading = false;
    notifyListeners();
  }
}
