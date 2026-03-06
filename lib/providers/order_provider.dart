import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;

  OrderProvider() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Load orders from storage or API
      _orders = [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder(OrderModel order) async {
    try {
      _orders.insert(0, order);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        final order = _orders[index];
        _orders[index] = OrderModel(
          id: order.id,
          userId: order.userId,
          items: order.items,
          subtotal: order.subtotal,
          deliveryFee: order.deliveryFee,
          tax: order.tax,
          total: order.total,
          deliveryAddress: order.deliveryAddress,
          paymentMethod: order.paymentMethod,
          status: status,
          orderDate: order.orderDate,
          estimatedDelivery: order.estimatedDelivery,
          notes: order.notes,
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    return updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  List<OrderModel> getUserOrders(String userId) {
    return _orders.where((o) => o.userId == userId).toList();
  }
}
