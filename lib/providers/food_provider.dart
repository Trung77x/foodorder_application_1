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
      image:
          'https://media.istockphoto.com/id/521471954/photo/fried-rice.jpg?s=612x612&w=0&k=20&c=SEyJMY9R-w_SxJr0XtPwHDHSPXGaUpOcnRfG-CvGLow=',
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
      image:
          'https://media.istockphoto.com/id/1161015185/photo/pho-bo-is-a-vietnamese-beef-noodle-soup-consisting-of-broth-rice-noodles-beef-meat.jpg?s=612x612&w=0&k=20&c=2T7n7xQzFvdQlGqx4xIBxFNLU0k2Kcvvj1u7bfJQNQQ=',
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
      image:
          'https://media.istockphoto.com/id/1198524203/photo/banh-mi-sandwich.jpg?s=612x612&w=0&k=20&c=gFLQy2S4D8_SaIc1wnCPZMIa5qsK1tIgJChJmAKVV88=',
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
      image:
          'https://media.istockphoto.com/id/613932620/photo/crispy-fried-chicken.jpg?s=612x612&w=0&k=20&c=XdmCqVj-bG0SfF2vNVh3EQQhqJa8LYHhsaLXiGGh6AE=',
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
      image:
          'https://media.istockphoto.com/id/1304800949/photo/grilled-pork-with-rice-noodles.jpg?s=612x612&w=0&k=20&c=D7YQnSWJHl1Vw2l2jrPqT1m0s5-Kx_G-Qhv6E8aJCfg=',
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
          'https://media.istockphoto.com/id/1350820651/photo/colorful-shaved-ice-dessert.jpg?s=612x612&w=0&k=20&c=nH9gJ7LmIzYX_G3mKLxhWPJcZnLk7wXpXSvK5lJQvH0=',
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
          'https://media.istockphoto.com/id/1328583241/photo/tomato-fried-rice-on-white-background.jpg?s=612x612&w=0&k=20&c=GHiJjgKxbLqyYkL7X0eQmHYvJHqH3dYWCd0m6UZzLdI=',
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
      image:
          'https://media.istockphoto.com/id/1307843877/photo/sizzling-crepe-with-shrimp-and-pork.jpg?s=612x612&w=0&k=20&c=6FWAqGbvZ_dKkpMpY1KxWPvMg34ZgSXLqUY0CtpL5tQ=',
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
      image:
          'https://media.istockphoto.com/id/1188803119/photo/crab-soup-with-vegetable.jpg?s=612x612&w=0&k=20&c=bJH4uXCr5nBfL2V3qRn0Kz_4sU7DhZnH7Jx5rq0sXZo=',
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
      image:
          'https://media.istockphoto.com/id/1328349157/photo/bubble-tea.jpg?s=612x612&w=0&k=20&c=4R7C5Z0gT1pP_qVoZT0l8OGHIpKh8pQ8gqIzH3tXsW4=',
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
