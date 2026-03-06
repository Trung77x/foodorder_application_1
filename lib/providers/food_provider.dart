import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../services/meal_api_service.dart';

class FoodProvider extends ChangeNotifier {
  // Use real TheMealDB images as default data (loads instantly)
  List<FoodModel> _foods = MealAPIService.getDefaultMeals();
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
    // Load more foods from API in background after construction
    Future.microtask(() => loadFoods());
  }

  Future<void> loadFoods() async {
    _isLoading = true;
    notifyListeners();

    try {
      final apiMeals = await MealAPIService.fetchAllMeals();

      if (apiMeals.isNotEmpty) {
        _foods = apiMeals;
      }
    } catch (e) {
      // Keep default meals on error
    }

    _isLoading = false;
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
