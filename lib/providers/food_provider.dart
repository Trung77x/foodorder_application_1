import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../services/meal_api_service.dart';

class FoodProvider extends ChangeNotifier {
  // Hardcode 12 foods with VERIFIED working TheMealDB image URLs
  List<FoodModel> _foods = [
    FoodModel(
      id: '52772',
      name: 'Teriyaki Chicken',
      description: 'Gà teriyaki nướng cùng rau củ, sốt ngọt đậm đà',
      price: 85000,
      image:
          'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
      category: 'Gà',
      rating: 5,
      reviews: 220,
      prepTime: 25,
    ),
    FoodModel(
      id: '52874',
      name: 'Beef and Mustard Pie',
      description: 'Bánh nướng nhân bò với mù tạt thơm phức',
      price: 95000,
      image:
          'https://www.themealdb.com/images/media/meals/sytuqu1511553755.jpg',
      category: 'Bò',
      rating: 5,
      reviews: 180,
      prepTime: 30,
    ),
    FoodModel(
      id: '52944',
      name: 'Escovitch Fish',
      description: 'Cá chiên giòn sốt chua cay kiểu Jamaica',
      price: 78000,
      image: 'https://www.themealdb.com/images/media/meals/1520084413.jpg',
      category: 'Hải sản',
      rating: 4,
      reviews: 150,
      prepTime: 20,
    ),
    FoodModel(
      id: '52893',
      name: 'Apple Crumble',
      description: 'Bánh nướng táo và mâm xôi, phủ lớp bơ giòn',
      price: 45000,
      image:
          'https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg',
      category: 'Tráng miệng',
      rating: 5,
      reviews: 95,
      prepTime: 15,
    ),
    FoodModel(
      id: '52835',
      name: 'Kung Pao Chicken',
      description: 'Gà xào cay kiểu Tứ Xuyên, đậu phộng giòn',
      price: 72000,
      image: 'https://www.themealdb.com/images/media/meals/1525872624.jpg',
      category: 'Gà',
      rating: 5,
      reviews: 310,
      prepTime: 18,
    ),
    FoodModel(
      id: '52997',
      name: 'Spicy Arrabiata Penne',
      description: 'Mì Penne sốt cà chua cay kiểu Ý, thơm lừng',
      price: 65000,
      image:
          'https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg',
      category: 'Mì Ý',
      rating: 4,
      reviews: 200,
      prepTime: 15,
    ),
    FoodModel(
      id: '53050',
      name: 'Ayam Percik',
      description: 'Gà nướng sốt dừa cay kiểu Malaysia',
      price: 88000,
      image:
          'https://www.themealdb.com/images/media/meals/020z181619788503.jpg',
      category: 'Gà',
      rating: 5,
      reviews: 175,
      prepTime: 35,
    ),
    FoodModel(
      id: '52832',
      name: 'Katsu Curry',
      description: 'Cơm cà ri gà chiên xù kiểu Nhật Bản',
      price: 82000,
      image:
          'https://www.themealdb.com/images/media/meals/vwrpps1503068729.jpg',
      category: 'Gà',
      rating: 5,
      reviews: 280,
      prepTime: 22,
    ),
    FoodModel(
      id: '52855',
      name: 'Banana Pancakes',
      description: 'Bánh kếp chuối mềm mịn, ngọt tự nhiên',
      price: 35000,
      image:
          'https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg',
      category: 'Tráng miệng',
      rating: 4,
      reviews: 130,
      prepTime: 10,
    ),
    FoodModel(
      id: '52773',
      name: 'Honey Teriyaki Salmon',
      description: 'Cá hồi sốt mật ong teriyaki, béo ngậy',
      price: 115000,
      image:
          'https://www.themealdb.com/images/media/meals/xxyupu1468262513.jpg',
      category: 'Hải sản',
      rating: 5,
      reviews: 260,
      prepTime: 20,
    ),
    FoodModel(
      id: '52977',
      name: 'Corba Lentil Soup',
      description: 'Súp đậu lăng Thổ Nhĩ Kỳ ấm bụng, giàu dinh dưỡng',
      price: 42000,
      image:
          'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
      category: 'Món phụ',
      rating: 4,
      reviews: 90,
      prepTime: 15,
    ),
    FoodModel(
      id: '52878',
      name: 'Lamb Rogan Josh',
      description: 'Cừu nấu cà ri đỏ kiểu Ấn Độ, đậm vị',
      price: 105000,
      image:
          'https://www.themealdb.com/images/media/meals/vvpprx1487325699.jpg',
      category: 'Cừu',
      rating: 5,
      reviews: 170,
      prepTime: 40,
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
    Future.microtask(() => loadFoods());
  }

  Future<void> loadFoods() async {
    try {
      final apiMeals = await MealAPIService.fetchAllMeals();
      if (apiMeals.isNotEmpty) {
        _foods = apiMeals;
        // Reset filter with new data
        if (_selectedCategory != 'All') {
          _filteredFoods = _foods
              .where((f) => f.category == _selectedCategory)
              .toList();
        }
      }
    } catch (e) {
      // Keep hardcoded meals on error
    }
    notifyListeners();
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

    try {
      final results = await MealAPIService.searchMeals(query);
      if (results.isNotEmpty) {
        _filteredFoods = results;
      } else {
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
