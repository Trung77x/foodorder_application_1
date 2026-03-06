import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import '../models/food_model.dart';

class MealAPIService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Fetch meals from multiple categories IN PARALLEL for speed
  static Future<List<FoodModel>> fetchAllMeals() async {
    final categories = [
      'Chicken',
      'Beef',
      'Seafood',
      'Dessert',
      'Pasta',
      'Pork',
    ];
    final random = Random();

    try {
      // Fetch all categories at once (parallel)
      final futures = categories.map(
        (cat) => http
            .get(Uri.parse('$baseUrl/filter.php?c=$cat'))
            .timeout(const Duration(seconds: 6)),
      );
      final responses = await Future.wait(futures, eagerError: false);

      final List<FoodModel> allMeals = [];
      for (int i = 0; i < responses.length; i++) {
        final response = responses[i];
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final meals = json['meals'] as List?;
          if (meals != null && meals.isNotEmpty) {
            final selected = (meals.toList()..shuffle(random)).take(3);
            for (final meal in selected) {
              final imageUrl = (meal['strMealThumb'] ?? '') as String;
              if (imageUrl.startsWith('http')) {
                allMeals.add(
                  FoodModel(
                    id: meal['idMeal'] ?? 'meal_${allMeals.length}',
                    name: meal['strMeal'] ?? 'Unknown',
                    description: _getVietnameseDesc(categories[i]),
                    price: _getPriceForCategory(categories[i], random),
                    image: imageUrl,
                    category: _translateCategory(categories[i]),
                    rating: 4 + random.nextInt(2),
                    reviews: 30 + random.nextInt(300),
                    prepTime: 10 + random.nextInt(30),
                    available: true,
                  ),
                );
              }
            }
          }
        }
      }

      if (allMeals.isNotEmpty) {
        allMeals.shuffle(random);
        return allMeals;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Search meals by name
  static Future<List<FoodModel>> searchMeals(String query) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/search.php?s=$query'))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;
        if (meals == null || meals.isEmpty) return [];

        final random = Random();
        return meals.map((meal) {
          final imageUrl = (meal['strMealThumb'] ?? '') as String;
          final cat = meal['strCategory'] ?? 'Other';
          return FoodModel(
            id: meal['idMeal'] ?? 'meal_0',
            name: meal['strMeal'] ?? 'Unknown',
            description: _getVietnameseDesc(cat),
            price: _getPriceForCategory(cat, random),
            image: imageUrl,
            category: _translateCategory(cat),
            rating: 4 + random.nextInt(2),
            reviews: 30 + random.nextInt(200),
            prepTime: 10 + random.nextInt(30),
            available: true,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static String _translateCategory(String category) {
    switch (category) {
      case 'Chicken':
        return 'Gà';
      case 'Beef':
        return 'Bò';
      case 'Seafood':
        return 'Hải sản';
      case 'Dessert':
        return 'Tráng miệng';
      case 'Pasta':
        return 'Mì Ý';
      case 'Pork':
        return 'Heo';
      case 'Lamb':
        return 'Cừu';
      case 'Side':
        return 'Món phụ';
      default:
        return category;
    }
  }

  static String _getVietnameseDesc(String category) {
    switch (category) {
      case 'Chicken':
        return 'Món gà thơm ngon, chế biến đa dạng';
      case 'Beef':
        return 'Thịt bò mềm, đậm đà hương vị';
      case 'Seafood':
        return 'Hải sản tươi sống, hương vị biển cả';
      case 'Dessert':
        return 'Tráng miệng ngọt ngào, hấp dẫn';
      case 'Pasta':
        return 'Mì Ý với sốt thơm lừng, béo ngậy';
      case 'Pork':
        return 'Thịt heo chế biến công phu';
      case 'Lamb':
        return 'Thịt cừu mềm, nêm nếm tinh tế';
      case 'Side':
        return 'Món phụ bổ sung dinh dưỡng';
      default:
        return 'Món ăn ngon miệng, hấp dẫn';
    }
  }

  static double _getPriceForCategory(String category, Random random) {
    switch (category) {
      case 'Chicken':
        return 70000 + random.nextInt(30) * 1000;
      case 'Beef':
        return 85000 + random.nextInt(30) * 1000;
      case 'Seafood':
        return 80000 + random.nextInt(40) * 1000;
      case 'Dessert':
        return 35000 + random.nextInt(20) * 1000;
      case 'Pasta':
        return 60000 + random.nextInt(25) * 1000;
      case 'Pork':
        return 65000 + random.nextInt(25) * 1000;
      case 'Lamb':
        return 95000 + random.nextInt(30) * 1000;
      default:
        return 55000 + random.nextInt(30) * 1000;
    }
  }
}
