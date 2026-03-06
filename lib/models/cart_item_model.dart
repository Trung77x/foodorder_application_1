import 'food_model.dart';

class CartItemModel {
  final String id;
  final FoodModel food;
  int quantity;
  final List<String> selectedAddons;

  CartItemModel({
    required this.id,
    required this.food,
    this.quantity = 1,
    this.selectedAddons = const [],
  });

  double get totalPrice => food.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food': food.toJson(),
      'quantity': quantity,
      'selectedAddons': selectedAddons,
    };
  }
}
