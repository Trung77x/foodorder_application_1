import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/food_model.dart';

class MealAPIService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Fetch meals by first letter with guaranteed images
  static Future<List<FoodModel>> getMealsByLetter(String letter) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/search.php?f=$letter'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;

        if (meals == null || meals.isEmpty) {
          return _getDefaultMeals();
        }

        return meals.asMap().entries.map((entry) {
          final index = entry.key;
          final meal = entry.value;

          // Ensure image URL is valid
          String imageUrl = meal['strMealThumb'] ?? '';
          if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
            imageUrl =
                'https://via.placeholder.com/300x300?text=${meal['strMeal'] ?? 'Food'}';
          }

          return FoodModel(
            id: meal['idMeal'] ?? 'meal_$index',
            name: meal['strMeal'] ?? 'Unknown Dish',
            description:
                (meal['strInstructions'] as String?)
                    ?.split('.')
                    .firstWhere(
                      (s) => s.isNotEmpty,
                      orElse: () => 'Delicious dish',
                    ) ??
                'Delicious dish from TheMealDB',
            price: 45000 + (index * 5000).toDouble(),
            image: imageUrl,
            category: meal['strCategory'] ?? 'Other',
            rating: 4 + (index % 2),
            reviews: 50 + (index * 10),
            prepTime: 15 + (index % 25),
            available: true,
          );
        }).toList();
      }
      return _getDefaultMeals();
    } catch (e) {
      return _getDefaultMeals();
    }
  }

  /// Get default meals with working images
  static List<FoodModel> _getDefaultMeals() {
    return [
      FoodModel(
        id: '1',
        name: 'Cơm Chiên Dương Châu',
        description: 'Cơm chiên với tôm, trứng, rau, hành',
        price: 85000,
        image:
            'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Com+Chien',
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
        description: 'Gà rán chiên giòn, ăn kèm nước mắm chua cay',
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
        image:
            'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Banh+Xeo',
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
            'https://via.placeholder.com/300x300/FF9500/FFFFFF?text=Canh+Cua',
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

            String imageUrl = meal['strMealThumb'] ?? '';
            if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
              imageUrl =
                  'https://via.placeholder.com/300x300?text=${meal['strMeal'] ?? 'Food'}';
            }

            meals.add(
              FoodModel(
                id: meal['idMeal'] ?? 'meal_$i',
                name: meal['strMeal'] ?? 'Unknown',
                description:
                    (meal['strInstructions'] as String?)
                        ?.split('.')
                        .firstWhere(
                          (s) => s.isNotEmpty,
                          orElse: () => 'Delicious dish',
                        ) ??
                    'Delicious dish',
                price: 45000 + (i * 5000).toDouble(),
                image: imageUrl,
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
      return meals.isNotEmpty ? meals : _getDefaultMeals();
    } catch (e) {
      return _getDefaultMeals();
    }
  }

  /// Get meals by category with images
  static Future<List<FoodModel>> getMealsByCategory(String category) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/filter.php?c=$category'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;

        if (meals == null || meals.isEmpty) {
          return _getDefaultMeals();
        }

        return meals.asMap().entries.map((entry) {
          final index = entry.key;
          final meal = entry.value;

          String imageUrl = meal['strMealThumb'] ?? '';
          if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
            imageUrl =
                'https://via.placeholder.com/300x300?text=${meal['strMeal'] ?? 'Food'}';
          }

          return FoodModel(
            id: meal['idMeal'] ?? 'meal_$index',
            name: meal['strMeal'] ?? 'Unknown',
            description: 'Delicious $category',
            price: 45000 + (index * 5000).toDouble(),
            image: imageUrl,
            category: category,
            rating: 4 + (index % 2),
            reviews: 50 + (index * 10),
            prepTime: 15 + (index % 25),
            available: true,
          );
        }).toList();
      }
      return _getDefaultMeals();
    } catch (e) {
      return _getDefaultMeals();
    }
  }

  /// Search meals by name with images
  static Future<List<FoodModel>> searchMeals(String query) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/search.php?s=$query'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;

        if (meals == null || meals.isEmpty) {
          return [];
        }

        return meals.asMap().entries.map((entry) {
          final index = entry.key;
          final meal = entry.value;

          String imageUrl = meal['strMealThumb'] ?? '';
          if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
            imageUrl =
                'https://via.placeholder.com/300x300?text=${meal['strMeal'] ?? 'Food'}';
          }

          return FoodModel(
            id: meal['idMeal'] ?? 'meal_$index',
            name: meal['strMeal'] ?? 'Unknown',
            description:
                (meal['strInstructions'] as String?)
                    ?.split('.')
                    .firstWhere(
                      (s) => s.isNotEmpty,
                      orElse: () => 'Delicious dish',
                    ) ??
                'Delicious dish',
            price: 45000 + (index * 5000).toDouble(),
            image: imageUrl,
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
