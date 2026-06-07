import 'cart_item_model.dart';

/// Sipariş durumu
enum OrderStatus {
  preparing,  // Hazırlanıyor
  onTheWay,   // Yolda
  delivered,  // Teslim edildi
  cancelled,  // İptal edildi
}

/// Sipariş veri modeli — REST API ile uyumlu
class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final String deliveryAddress;
  final DateTime createdAt;
  final String? note;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.status = OrderStatus.preparing,
    required this.deliveryAddress,
    DateTime? createdAt,
    this.note,
  }) : createdAt = createdAt ?? DateTime.now();

  String get statusText {
    switch (status) {
      case OrderStatus.preparing:
        return 'Hazırlanıyor';
      case OrderStatus.onTheWay:
        return 'Yolda';
      case OrderStatus.delivered:
        return 'Teslim Edildi';
      case OrderStatus.cancelled:
        return 'İptal Edildi';
    }
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: (map['id'] ?? '').toString(),
      userId: map['userId'] ?? map['user_id'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? map['delivery_fee'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'preparing'),
        orElse: () => OrderStatus.preparing,
      ),
      deliveryAddress: map['deliveryAddress'] ?? map['delivery_address'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'].toString())
          : DateTime.now(),
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status.name,
      'deliveryAddress': deliveryAddress,
      'createdAt': createdAt.toIso8601String(),
      'note': note,
    };
  }

  @override
  String toString() =>
      'OrderModel(id: $id, items: ${items.length}, total: $total, status: $statusText)';
}
