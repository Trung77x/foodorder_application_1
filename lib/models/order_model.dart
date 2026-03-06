import 'cart_item_model.dart';
import 'food_model.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  outForDelivery,
  delivered,
  cancelled,
}

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String deliveryAddress;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime? estimatedDelivery;
  final String? notes;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    required this.orderDate,
    this.estimatedDelivery,
    this.notes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items:
          (json['items'] as List?)
              ?.map(
                (e) => CartItemModel(
                  id: e['id'] ?? '',
                  food: FoodModel(
                    id: e['foodId'] ?? '',
                    name: e['name'] ?? '',
                    description: e['description'] ?? '',
                    price: (e['price'] ?? 0).toDouble(),
                    image: e['image'] ?? '',
                    category: e['category'] ?? '',
                  ),
                  quantity: e['quantity'] ?? 1,
                ),
              )
              .toList() ??
          [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      deliveryAddress: json['deliveryAddress'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'cash',
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status'] ?? 'pending'}',
        orElse: () => OrderStatus.pending,
      ),
      orderDate: DateTime.tryParse(json['orderDate'] ?? '') ?? DateTime.now(),
      estimatedDelivery: DateTime.tryParse(json['estimatedDelivery'] ?? ''),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'status': status.toString().split('.').last,
      'orderDate': orderDate.toIso8601String(),
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'notes': notes,
    };
  }
}
