import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/food_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get tax => subtotal * 0.1;
  double get deliveryFee => subtotal > 100 ? 0 : 50;
  double get total => subtotal + tax + deliveryFee;

  int get itemCount => _items.length;
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(FoodModel food, {List<String> addons = const []}) {
    final existingIndex = _items.indexWhere((item) => item.food.id == food.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(
        CartItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          food: food,
          quantity: 1,
          selectedAddons: addons,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = quantity;
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void removeFoodItem(String foodId) {
    _items.removeWhere((item) => item.food.id == foodId);
    notifyListeners();
  }
}
