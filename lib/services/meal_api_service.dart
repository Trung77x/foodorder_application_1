import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/food_model.dart';

class MealAPIService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Fetch meals by first letter
  static Future<List<FoodModel>> getMealsByLetter(String letter) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/search.php?f=$letter'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;

        if (meals == null) return [];

        return meals.asMap().entries.map((entry) {
          final index = entry.key;
          final meal = entry.value;
          return FoodModel(
            id: meal['idMeal'] ?? 'meal_$index',
            name: meal['strMeal'] ?? 'Unknown',
            description:
                meal['strInstructions']?.toString().split('.')[0] ??
                'Delicious meal from TheMealDB',
            price:
                45000 +
                (index * 5000).toDouble(), // Dynamic pricing based on index
            image: meal['strMealThumb'] ?? '',
            category: meal['strCategory'] ?? 'Other', // Use actual category
            rating: 4 + (index % 2), // Alternate between 4 and 5
            reviews: 50 + (index * 10),
            prepTime: 15 + (index % 25),
            available: true,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Fetch random meals
  static Future<List<FoodModel>> getRandomMeals(int count) async {
    List<FoodModel> meals = [];
    try {
      for (int i = 0; i < count; i++) {
        final response = await http
            .get(Uri.parse('$baseUrl/random.php'))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final mealList = json['meals'] as List?;

          if (mealList != null && mealList.isNotEmpty) {
            final meal = mealList[0];
            meals.add(
              FoodModel(
                id: meal['idMeal'] ?? 'meal_$i',
                name: meal['strMeal'] ?? 'Unknown',
                description:
                    meal['strInstructions']?.toString().split('.')[0] ??
                    'Delicious meal',
                price: 45000 + (i * 5000).toDouble(),
                image: meal['strMealThumb'] ?? '',
                category: meal['strCategory'] ?? 'Other',
                rating: 4 + (i % 2),
                reviews: 50 + (i * 10),
                prepTime: 15 + (i % 25),
                available: true,
              ),
            );
          }
        }
      }
      return meals;
    } catch (e) {
      return meals;
    }
  }

  /// Get meals by category
  static Future<List<FoodModel>> getMealsByCategory(String category) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/filter.php?c=$category'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;

        if (meals == null) return [];

        return meals.asMap().entries.map((entry) {
          final index = entry.key;
          final meal = entry.value;
          return FoodModel(
            id: meal['idMeal'] ?? 'meal_$index',
            name: meal['strMeal'] ?? 'Unknown',
            description: 'Delicious $category from TheMealDB',
            price: 45000 + (index * 5000).toDouble(),
            image: meal['strMealThumb'] ?? '',
            category: category,
            rating: 4 + (index % 2),
            reviews: 50 + (index * 10),
            prepTime: 15 + (index % 25),
            available: true,
          );
        }).toList();
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
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;

        if (meals == null) return [];

        return meals.asMap().entries.map((entry) {
          final index = entry.key;
          final meal = entry.value;
          return FoodModel(
            id: meal['idMeal'] ?? 'meal_$index',
            name: meal['strMeal'] ?? 'Unknown',
            description:
                meal['strInstructions']?.toString().split('.')[0] ??
                'Delicious meal',
            price: 45000 + (index * 5000).toDouble(),
            image: meal['strMealThumb'] ?? '',
            category: meal['strCategory'] ?? 'Other',
            rating: 4 + (index % 2),
            reviews: 50 + (index * 10),
            prepTime: 15 + (index % 25),
            available: true,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
