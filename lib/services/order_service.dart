import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import 'api_service.dart';

/// Sipariş işlemlerini REST API üzerinden yöneten servis
class OrderService {
  final ApiService _api = ApiService();

  /// Yeni sipariş oluşturur, sipariş ID'sini döndürür
  Future<String> createOrder({
    required String userId,
    required List<CartItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String deliveryAddress,
    String? note,
  }) async {
    final res = await _api.post('/orders', data: {
      'userId': userId,
      'items': items.map((item) => {
        'pizza': item.pizza.toMap(),
        'selectedSize': item.selectedSize,
        'quantity': item.quantity,
        'extraIngredients': item.extraIngredients,
        'unitPrice': item.unitPrice,
        'totalPrice': item.totalPrice,
      }).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'note': note,
    });

    if (res.data['success'] == true) {
      return res.data['data']['orderId'].toString();
    }
    throw res.data['message'] ?? 'Sipariş oluşturulamadı.';
  }

  /// Kullanıcının sipariş geçmişini çeker
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final res = await _api.get('/orders/user/$userId');
      if (res.data['success'] == true) {
        return (res.data['data'] as List).map((e) => OrderModel.fromMap(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
