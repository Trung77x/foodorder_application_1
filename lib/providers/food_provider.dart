import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../services/meal_api_service.dart';

class FoodProvider extends ChangeNotifier {
  List<FoodModel> _foods = [
    FoodModel(
      id: '1',
      name: 'Cơm Chiên Dương Châu',
      description: 'Cơm chiên với tôm, trứng, rau, hành',
      price: 85000,
      image: 'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Com+Chien',
      category: 'Cơm',
      rating: 5,
      reviews: 120,
      prepTime: 15,
    ),
    FoodModel(
      id: '2',
      name: 'Phở Bò',
      description: 'Phở bò tươi, nước dùng thơm ngon',
      price: 75000,
      image: 'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Pho+Bo',
      category: 'Mì & Phở',
      rating: 5,
      reviews: 230,
      prepTime: 20,
    ),
    FoodModel(
      id: '3',
      name: 'Bánh Mì Thập Cẩm',
      description: 'Bánh mì giòn với pâté, thịt lạp xưởng, rau',
      price: 45000,
      image: 'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Banh+Mi',
      category: 'Bánh',
      rating: 4,
      reviews: 180,
      prepTime: 10,
    ),
    FoodModel(
      id: '4',
      name: 'Gà Rán Giòn',
      description: 'Gà rán chiên giòn, ăn kèm nước mắm',
      price: 89000,
      image: 'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Ga+Ran',
      category: 'Gà',
      rating: 5,
      reviews: 290,
      prepTime: 12,
    ),
    FoodModel(
      id: '5',
      name: 'Bún Chả',
      description: 'Bún tươi với thịt nướng, nước mắm',
      price: 55000,
      image: 'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Bun+Cha',
      category: 'Bún',
      rating: 4,
      reviews: 150,
      prepTime: 15,
    ),
    FoodModel(
      id: '6',
      name: 'Chè Ba Màu',
      description: 'Chè ba màu ngon mát, giải nhiệt mùa hè',
      price: 25000,
      image:
          'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Che+Ba+Mau',
      category: 'Tráng Miệng',
      rating: 4,
      reviews: 95,
      prepTime: 3,
    ),
    FoodModel(
      id: '7',
      name: 'Cơm Cà Chua Trứng',
      description: 'Cơm chiên cà chua tươi mát, trứng nổi',
      price: 65000,
      image:
          'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Com+Ca+Chua',
      category: 'Cơm',
      rating: 5,
      reviews: 110,
      prepTime: 15,
    ),
    FoodModel(
      id: '8',
      name: 'Bánh Xèo',
      description: 'Bánh xèo vàng, giòn, ăn kèm rau sống',
      price: 48000,
      image: 'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Banh+Xeo',
      category: 'Bánh',
      rating: 4,
      reviews: 140,
      prepTime: 10,
    ),
    FoodModel(
      id: '9',
      name: 'Canh Cua',
      description: 'Canh cua nóng, thanh mát, bổ dưỡng',
      price: 95000,
      image: 'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Canh+Cua',
      category: 'Canh',
      rating: 5,
      reviews: 85,
      prepTime: 25,
    ),
    FoodModel(
      id: '10',
      name: 'Trà Sữa Trân Châu',
      description: 'Trà sữa thơm ngon với trân châu dẻo',
      price: 35000,
      image: 'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Tra+Sua',
      category: 'Đồ Uống',
      rating: 5,
      reviews: 320,
      prepTime: 5,
    ),
  ];
  List<FoodModel> _filteredFoods = [];
  bool _isLoading = false;
  String _selectedCategory = 'All';

  List<FoodModel> get foods => _filteredFoods.isEmpty ? _foods : _filteredFoods;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  List<String> get categories {
    final cats = <String>{'All'};
    cats.addAll(_foods.map((f) => f.category).toSet());
    return cats.toList();
  }

  FoodProvider() {
    // Load API data in background after construction
    Future.microtask(() => loadFoods());
  }

  Future<void> loadFoods() async {
    try {
      // Try fetching from TheMealDB API
      final apiMeals = await MealAPIService.getMealsByLetter('a');

      if (apiMeals.isNotEmpty) {
        _foods = apiMeals;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    if (category == 'All') {
      _filteredFoods = [];
    } else {
      _filteredFoods = _foods.where((f) => f.category == category).toList();
    }
    notifyListeners();
  }

  void searchFoods(String query) async {
    if (query.isEmpty) {
      _filteredFoods = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Try to search from API first
      final results = await MealAPIService.searchMeals(query);

      if (results.isNotEmpty) {
        _filteredFoods = results;
      } else {
        // Fallback to local search
        _filteredFoods = _foods
            .where(
              (f) =>
                  f.name.toLowerCase().contains(query.toLowerCase()) ||
                  f.description.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    } catch (e) {
      _filteredFoods = _foods
          .where(
            (f) =>
                f.name.toLowerCase().contains(query.toLowerCase()) ||
                f.description.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    _isLoading = false;
    notifyListeners();
  }

  FoodModel? getFoodById(String id) {
    try {
      return _foods.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }
}
