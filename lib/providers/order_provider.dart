import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;

  // === Tải đơn hàng từ Firestore theo userId ===
  Future<void> loadOrdersFromFirestore(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('orderDate', descending: true)
          .get();

      _orders.clear();
      for (final doc in snapshot.docs) {
        _orders.add(OrderModel.fromJson(doc.data()));
      }
    } catch (e) {
      // Firestore index chưa tạo — fallback không orderBy, sort thủ công
      try {
        final snapshot = await _firestore
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .get();
        _orders.clear();
        final loaded = snapshot.docs
            .map((doc) => OrderModel.fromJson(doc.data()))
            .toList();
        loaded.sort((a, b) => b.orderDate.compareTo(a.orderDate));
        _orders.addAll(loaded);
      } catch (e2) {
        debugPrint('Error loading orders from Firestore: $e2');
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createOrder(OrderModel order) async {
    try {
      // Lưu lên Firestore
      await _firestore.collection('orders').doc(order.id).set(order.toJson());

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
        final updatedOrder = OrderModel(
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

        // Cập nhật trên Firestore
        await _firestore.collection('orders').doc(orderId).update({
          'status': status.toString().split('.').last,
        });

        _orders[index] = updatedOrder;
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
