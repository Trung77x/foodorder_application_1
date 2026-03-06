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
                    name: _translateMealName(meal['strMeal'] ?? 'Unknown'),
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
            name: _translateMealName(meal['strMeal'] ?? 'Unknown'),
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

  /// Translate English meal names to Vietnamese
  static String _translateMealName(String name) {
    const map = {
      // Chicken
      'Chicken Handi': 'Gà Hầm Ấn Độ',
      'Chicken Marengo': 'Gà Sốt Cà Chua Kiểu Pháp',
      'Chicken Couscous': 'Gà Nấu Couscous',
      'Chicken Fajita Mac and Cheese': 'Mì Phô Mai Gà Fajita',
      'Chicken Enchilada Casserole': 'Gà Nướng Phô Mai Mexico',
      'Chicken Congee': 'Cháo Gà',
      'Chicken Karaage': 'Gà Chiên Kiểu Nhật',
      'Chicken Parmentier': 'Gà Nướng Khoai Tây',
      'Brown Stew Chicken': 'Gà Kho Nâu',
      'Chick-Fil-A Sandwich': 'Sandwich Gà Chiên',
      'Chicken Alfredo Primavera': 'Mì Gà Sốt Kem',
      'General Tso\'s Chicken': 'Gà Chiên Sốt Cay Ngọt',
      'Honey Balsamic Chicken with Crispy Broccoli & Potatoes':
          'Gà Sốt Mật Ong Bông Cải',
      'Katsu Curry': 'Cơm Cà Ri Gà Chiên Xù',
      'Kentucky Fried Chicken': 'Gà Rán Kentucky',
      'Kung Pao Chicken': 'Gà Xào Cay Tứ Xuyên',
      'Pad See Ew': 'Mì Xào Thái Lan',
      'Thai Green Curry': 'Cà Ri Xanh Thái',
      'Teriyaki Chicken Casserole': 'Gà Nướng Teriyaki',
      'Ayam Percik': 'Gà Nướng Sốt Dừa',
      'Chicken & mushroom Hotpot': 'Lẩu Gà Nấm',
      'Chicken Ham and Leek Pie': 'Bánh Gà Giăm Bông',
      'Chicken Quinoa Greek Salad': 'Salad Gà Kiểu Hy Lạp',
      'Coq au vin': 'Gà Hầm Rượu Vang',
      'Jerk chicken with rice & peas': 'Gà Nướng Jamaica',
      'Piri-piri chicken and slaw': 'Gà Nướng Piri-piri',
      'Tandoori chicken': 'Gà Nướng Tandoori',
      // Beef
      'Beef and Mustard Pie': 'Bánh Nướng Bò Mù Tạt',
      'Beef and Oyster pie': 'Bánh Nướng Bò Hàu',
      'Beef Banh Mi Bowls with Sriracha Mayo': 'Bò Bánh Mì Sốt Sriracha',
      'Beef Bourguignon': 'Bò Hầm Rượu Vang Pháp',
      'Beef Brisket Pot Roast': 'Bò Nướng Chảo',
      'Beef Caldereta': 'Bò Hầm Cà Chua Philippines',
      'Beef Dumpling Stew': 'Bò Hầm Bánh Bao',
      'Beef Lo Mein': 'Mì Xào Bò',
      'Beef Rendang': 'Bò Rendang',
      'Beef stroganoff': 'Bò Stroganoff Sốt Kem',
      'Beef Sunday Roast': 'Bò Nướng Chủ Nhật',
      'Braised Beef Chilli': 'Bò Hầm Ớt Cay',
      'Big Mac': 'Hamburger Bò',
      'Corned Beef and Cabbage': 'Bò Muối Bắp Cải',
      'Massaman Beef curry': 'Cà Ri Bò Massaman',
      'Minced Beef Pie': 'Bánh Bò Xay',
      'Mongolian Beef': 'Bò Xào Mông Cổ',
      'Mulukhiyah': 'Bò Hầm Rau Đay',
      'Oxtail with broad beans': 'Đuôi Bò Hầm Đậu',
      'Red Peas Soup': 'Súp Bò Đậu Đỏ',
      'Steak and Kidney Pie': 'Bánh Bò Thận',
      'Steak Diane': 'Bò Bít Tết Diane',
      'Szechuan Beef': 'Bò Xào Tứ Xuyên',
      // Seafood
      'Baked salmon with fennel & tomatoes': 'Cá Hồi Nướng Cà Chua',
      'Cajun spiced fish tacos': 'Taco Cá Cajun',
      'Escovitch Fish': 'Cá Chiên Sốt Chua Cay',
      'Fish fridge pie': 'Bánh Cá Nướng',
      'Fish pie': 'Bánh Cá Kiểu Anh',
      'Fish Stew with Rouille': 'Cá Hầm Sốt Rouille',
      'Garides Saganaki': 'Tôm Nướng Phô Mai Hy Lạp',
      'Grilled Portuguese sardines': 'Cá Mòi Nướng Bồ Đào Nha',
      'Honey Teriyaki Salmon': 'Cá Hồi Sốt Mật Ong',
      'Kedgeree': 'Cơm Cá Hun Khói',
      'Kung Po Prawns': 'Tôm Xào Cay Tứ Xuyên',
      'Laksa King Prawn Noodles': 'Mì Tôm Laksa',
      'Mediterranean Pasta Salad': 'Salad Mì Hải Sản',
      'Mee goreng mamak': 'Mì Xào Hải Sản',
      'Nasi lemak': 'Cơm Dừa Hải Sản',
      'Portuguese fish stew (Caldeirada)': 'Cá Hầm Bồ Đào Nha',
      'Recheado Masala Fish': 'Cá Nướng Masala Ấn Độ',
      'Salmon Avocado Salad': 'Salad Cá Hồi Bơ',
      'Salmon Prawn Risotto': 'Cơm Risotto Cá Hồi Tôm',
      'Seafood fideuà': 'Mì Hải Sản Tây Ban Nha',
      'Shrimp Chow Fun': 'Hủ Tiếu Xào Tôm',
      'Spaghetti alla Norma': 'Mì Ý Cà Tím',
      'Three Fish Pie': 'Bánh Ba Loại Cá',
      'Tuna and Egg Briks': 'Bánh Cá Ngừ Trứng',
      'Tuna Nicoise': 'Salad Cá Ngừ Nicoise',
      // Dessert
      'Apam balik': 'Bánh Kếp Đậu Phộng',
      'Apple & Blackberry Crumble': 'Bánh Táo Nướng Giòn',
      'Apple Frangipan Tart': 'Bánh Tart Táo Hạnh Nhân',
      'Banana Pancakes': 'Bánh Kếp Chuối',
      'Battenberg Cake': 'Bánh Battenberg',
      'BeaverTails': 'Bánh Đuôi Hải Ly',
      'Blackberry Fool': 'Kem Mâm Xôi',
      'Bread and Butter Pudding': 'Bánh Pudding Bơ',
      'Budino Di Ricotta': 'Bánh Pudding Ricotta',
      'Canadian Butter Tarts': 'Bánh Tart Bơ Canada',
      'Carrot Cake': 'Bánh Cà Rốt',
      'Cashew Ghoriba Biscuits': 'Bánh Quy Hạt Điều',
      'Chelsea Buns': 'Bánh Cuộn Chelsea',
      'Chinon Apple Tarts': 'Bánh Tart Táo Chinon',
      'Chocolate Avocado Mousse': 'Mousse Sô Cô La Bơ',
      'Chocolate Caramel Crispy': 'Bánh Xốp Sô Cô La Caramel',
      'Chocolate Gateau': 'Bánh Gato Sô Cô La',
      'Chocolate Raspberry Brownies': 'Brownie Sô Cô La Mâm Xôi',
      'Chocolate Souffle': 'Bánh Soufflé Sô Cô La',
      'Christmas Pudding Flapjack': 'Bánh Yến Mạch Giáng Sinh',
      'Christmas cake': 'Bánh Giáng Sinh',
      'Classic Christmas Pudding': 'Pudding Giáng Sinh',
      'Eccles Cakes': 'Bánh Eccles',
      'Eton Mess': 'Kem Dâu Eton Mess',
      'Honey Yogurt Cheesecake': 'Cheesecake Mật Ong Sữa Chua',
      'Hot Chocolate Fudge': 'Kẹo Sô Cô La Nóng',
      'Jam Roly-Poly': 'Bánh Cuộn Mứt',
      'Key Lime Pie': 'Bánh Chanh Key Lime',
      'Krispy Kreme Donut': 'Bánh Donut Krispy',
      'Kunafeh': 'Bánh Kunafeh Phô Mai',
      'Lemon Meringue Pie': 'Bánh Chanh Meringue',
      'Madeira Cake': 'Bánh Bông Lan Madeira',
      'Nanaimo Bars': 'Bánh Nanaimo',
      'New York cheesecake': 'Cheesecake New York',
      'Pancakes': 'Bánh Kếp',
      'Panna Cotta': 'Panna Cotta Kem Ý',
      'Parkin Cake': 'Bánh Gừng Parkin',
      'Peach & Blueberry Grunt': 'Bánh Đào Việt Quất',
      'Peanut Butter Cheesecake': 'Cheesecake Bơ Đậu Phộng',
      'Peanut Butter Cookies': 'Bánh Quy Bơ Đậu Phộng',
      'Pear Tatin': 'Bánh Lê Tatin',
      'Polskie Nalesniki': 'Bánh Kếp Ba Lan',
      'Portuguese Custard Tarts': 'Bánh Trứng Bồ Đào Nha',
      'Pouding chomeur': 'Pudding Siro Cây Phong',
      'Spotted Dick': 'Bánh Pudding Nho Khô',
      'Sticky Toffee Pudding': 'Pudding Toffee Dẻo',
      'Sticky Toffee Pudding Ultimate': 'Pudding Toffee Siêu Ngon',
      'Strawberry Rhubarb Pie': 'Bánh Dâu Tây',
      'Sugar Pie': 'Bánh Đường',
      'Suki Yaki': 'Lẩu Sukiyaki Nhật',
      'Summer Pudding': 'Pudding Trái Cây Mùa Hè',
      'Tarte Tatin': 'Bánh Tart Tatin',
      'Timbits': 'Bánh Donut Mini',
      'Treacle Tart': 'Bánh Tart Mật Mía',
      'Turkish Delight': 'Kẹo Thổ Nhĩ Kỳ',
      'Walnut Roll Gužvara': 'Bánh Cuộn Hạt Óc Chó',
      'White Chocolate Creme Brulee': 'Kem Brulée Sô Cô La Trắng',
      // Pasta
      'Lasagne': 'Mì Lasagne Bò Phô Mai',
      'Lasagna': 'Mì Lasagne Bò Phô Mai',
      'Penne alla Norma': 'Mì Penne Cà Tím',
      'Pilchard puttanesca': 'Mì Ý Cá Mòi',
      'Pork Cassoulet': 'Mì Ý Hầm Heo',
      'Rigatoni with fennel sausage sauce': 'Mì Rigatoni Xúc Xích',
      'Spaghetti Bolognese': 'Mì Ý Sốt Bò Bằm',
      'Spicy Arrabiata Penne': 'Mì Ý Sốt Cà Chua Cay',
      'Venetian Duck Ragu': 'Mì Ý Sốt Vịt Venice',
      'e Pepe': 'Mì Tiêu Phô Mai',
      'Fettucine alfance': 'Mì Fettuccine Sốt Kem',
      'Fettuccine Alfredo': 'Mì Fettuccine Sốt Kem',
      // Pork
      'BBQ Pork Sloppy Joes': 'Bánh Mì Heo BBQ',
      'Crispy Sausages and Greens': 'Xúc Xích Chiên Giòn Rau Xanh',
      'Dried Fruit Pilaf with Lamb Chops and Orange Butter':
          'Cơm Trái Cây Khô Sườn Cừu',
      'French Onion Chicken with Pasta': 'Mì Gà Hành Tây Pháp',
      'Glazed Pork Chops': 'Sườn Heo Nướng Sốt Mật',
      'Hot and Sour Soup': 'Súp Chua Cay',
      'Katsu Chicken curry': 'Gà Katsu Cà Ri',
      'Pork Chops with Roasted Garlic': 'Sườn Heo Nướng Tỏi',
      'Pork Cassoulet': 'Heo Hầm Đậu Pháp',
      'Pork Teriyaki': 'Heo Teriyaki',
      'Pozole Verde con Pollo': 'Súp Heo Xanh Mexico',
      'Ribs': 'Sườn Heo Nướng BBQ',
      'Skewers with Satay Sauce': 'Xiên Heo Sốt Satay',
      'Stuffed Lamb Tomatoes': 'Cà Chua Nhồi Thịt',
      'Tonkatsu pridge': 'Heo Chiên Xù Nhật Bản',
      'Vietnamese Grilled Pork': 'Thịt Heo Nướng Việt Nam',
      'Wontons': 'Hoành Thánh',
    };
    return map[name] ?? _autoTranslate(name);
  }

  /// Auto-translate common English food words to Vietnamese
  static String _autoTranslate(String name) {
    String result = name;
    final translations = {
      'Chicken': 'Gà',
      'Beef': 'Bò',
      'Pork': 'Heo',
      'Lamb': 'Cừu',
      'Fish': 'Cá',
      'Salmon': 'Cá Hồi',
      'Shrimp': 'Tôm',
      'Prawn': 'Tôm',
      'Prawns': 'Tôm',
      'Soup': 'Súp',
      'Stew': 'Hầm',
      'Roast': 'Nướng',
      'Grilled': 'Nướng',
      'Fried': 'Chiên',
      'Baked': 'Nướng Lò',
      'Curry': 'Cà Ri',
      'Salad': 'Salad',
      'Pie': 'Bánh Nướng',
      'Cake': 'Bánh Ngọt',
      'Pancake': 'Bánh Kếp',
      'Pancakes': 'Bánh Kếp',
      'Rice': 'Cơm',
      'Noodles': 'Mì',
      'Pasta': 'Mì Ý',
      'Spicy': 'Cay',
      'Sweet': 'Ngọt',
      'Crispy': 'Giòn',
      'Cream': 'Kem',
      'Chocolate': 'Sô Cô La',
      'Cheese': 'Phô Mai',
      'Honey': 'Mật Ong',
      'Garlic': 'Tỏi',
      'Lemon': 'Chanh',
      'Mushroom': 'Nấm',
      'Egg': 'Trứng',
      'Tomato': 'Cà Chua',
      'Potato': 'Khoai Tây',
      'Sausage': 'Xúc Xích',
      'Sandwich': 'Sandwich',
      'Burger': 'Hamburger',
      'Taco': 'Taco',
      'Wrap': 'Cuốn',
    };
    // Try replacing keywords
    translations.forEach((eng, viet) {
      result = result.replaceAll(eng, viet);
    });
    // If nothing changed, return original
    return result == name ? name : result;
  }
}
