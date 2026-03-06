import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import '../models/food_model.dart';

class MealAPIService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  /// Fetch a full list of meals from multiple categories for the home screen
  static Future<List<FoodModel>> fetchAllMeals() async {
    final List<FoodModel> allMeals = [];
    final categories = [
      'Chicken',
      'Beef',
      'Seafood',
      'Dessert',
      'Pasta',
      'Pork',
      'Lamb',
      'Side',
    ];
    final random = Random();

    try {
      for (final category in categories) {
        final response = await http
            .get(Uri.parse('$baseUrl/filter.php?c=$category'))
            .timeout(const Duration(seconds: 8));

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final meals = json['meals'] as List?;

          if (meals != null && meals.isNotEmpty) {
            // Take up to 3 meals per category for variety
            final selected = (meals.toList()..shuffle(random)).take(3);
            for (final meal in selected) {
              final imageUrl = meal['strMealThumb'] ?? '';
              if (imageUrl.isNotEmpty) {
                allMeals.add(
                  FoodModel(
                    id: meal['idMeal'] ?? 'meal_${allMeals.length}',
                    name: meal['strMeal'] ?? 'Unknown Dish',
                    description: _getVietnameseDesc(category),
                    price: _getPriceForCategory(category, random),
                    image: '$imageUrl/preview',
                    category: _translateCategory(category),
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
      return getDefaultMeals();
    } catch (e) {
      return getDefaultMeals();
    }
  }

  /// Get meal detail by ID (for full description)
  static Future<FoodModel?> getMealDetail(String id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/lookup.php?i=$id'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;
        if (meals != null && meals.isNotEmpty) {
          final meal = meals[0];
          final imageUrl = meal['strMealThumb'] ?? '';
          final instructions = (meal['strInstructions'] as String?) ?? '';
          final desc = instructions
              .split('.')
              .where((s) => s.trim().isNotEmpty)
              .take(2)
              .join('. ');

          return FoodModel(
            id: meal['idMeal'] ?? id,
            name: meal['strMeal'] ?? 'Unknown',
            description: desc.isNotEmpty ? '$desc.' : 'Delicious dish',
            price: 55000,
            image: imageUrl.isNotEmpty ? '$imageUrl/preview' : '',
            category: _translateCategory(meal['strCategory'] ?? 'Other'),
            rating: 5,
            reviews: 100,
            prepTime: 20,
            available: true,
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Search meals by name
  static Future<List<FoodModel>> searchMeals(String query) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/search.php?s=$query'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final meals = json['meals'] as List?;

        if (meals == null || meals.isEmpty) return [];

        final random = Random();
        return meals.map((meal) {
          final imageUrl = meal['strMealThumb'] ?? '';
          final cat = meal['strCategory'] ?? 'Other';
          final instructions = (meal['strInstructions'] as String?) ?? '';
          final desc = instructions
              .split('.')
              .where((s) => s.trim().isNotEmpty)
              .take(1)
              .join('. ');

          return FoodModel(
            id: meal['idMeal'] ?? 'meal_0',
            name: meal['strMeal'] ?? 'Unknown',
            description: desc.isNotEmpty ? '$desc.' : 'Delicious dish',
            price: _getPriceForCategory(cat, random),
            image: imageUrl.isNotEmpty ? '$imageUrl/preview' : '',
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

  /// Default meals with REAL TheMealDB images (known valid IDs)
  static List<FoodModel> getDefaultMeals() {
    return [
      FoodModel(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
        description: 'Gà teriyaki nướng cùng rau củ, sốt ngọt đậm đà',
        price: 85000,
        image:
            'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg/preview',
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
            'https://www.themealdb.com/images/media/meals/sytuqu1511553755.jpg/preview',
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
        image:
            'https://www.themealdb.com/images/media/meals/1520084413.jpg/preview',
        category: 'Hải sản',
        rating: 4,
        reviews: 150,
        prepTime: 20,
      ),
      FoodModel(
        id: '52893',
        name: 'Apple & Blackberry Crumble',
        description: 'Bánh nướng táo và mâm xôi, phủ lớp bơ giòn',
        price: 45000,
        image:
            'https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg/preview',
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
        image:
            'https://www.themealdb.com/images/media/meals/1525872624.jpg/preview',
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
            'https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg/preview',
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
            'https://www.themealdb.com/images/media/meals/020z181619788503.jpg/preview',
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
            'https://www.themealdb.com/images/media/meals/vwrpps1503068729.jpg/preview',
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
            'https://www.themealdb.com/images/media/meals/sywswr1511383814.jpg/preview',
        category: 'Tráng miệng',
        rating: 4,
        reviews: 130,
        prepTime: 10,
      ),
      FoodModel(
        id: '52773',
        name: 'Honey Teriyaki Salmon',
        description: 'Cá hồi sốt mật ong teriyaki, thơm ngon béo ngậy',
        price: 115000,
        image:
            'https://www.themealdb.com/images/media/meals/xxyupu1468262513.jpg/preview',
        category: 'Hải sản',
        rating: 5,
        reviews: 260,
        prepTime: 20,
      ),
      FoodModel(
        id: '52977',
        name: 'Corba (Lentil Soup)',
        description: 'Súp đậu lăng Thổ Nhĩ Kỳ ấm bụng, giàu dinh dưỡng',
        price: 42000,
        image:
            'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg/preview',
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
            'https://www.themealdb.com/images/media/meals/vvpprx1487325699.jpg/preview',
        category: 'Cừu',
        rating: 5,
        reviews: 170,
        prepTime: 40,
      ),
    ];
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
      case 'Starter':
        return 'Khai vị';
      case 'Vegetarian':
        return 'Chay';
      case 'Breakfast':
        return 'Bữa sáng';
      case 'Miscellaneous':
        return 'Khác';
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
      case 'Side':
        return 35000 + random.nextInt(20) * 1000;
      default:
        return 55000 + random.nextInt(30) * 1000;
    }
  }
}
