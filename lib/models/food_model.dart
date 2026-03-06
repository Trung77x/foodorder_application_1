class FoodModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final int rating;
  final int reviews;
  final int prepTime;
  final bool available;

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.rating = 5,
    this.reviews = 0,
    this.prepTime = 30,
    this.available = true,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      rating: json['rating'] ?? 5,
      reviews: json['reviews'] ?? 0,
      prepTime: json['prepTime'] ?? 30,
      available: json['available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'rating': rating,
      'reviews': reviews,
      'prepTime': prepTime,
      'available': available,
    };
  }
}
