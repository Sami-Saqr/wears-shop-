import '../utils/constants.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String category;
  final int? categoryId;
  final bool bestSeller;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.category,
    this.categoryId,
    this.bestSeller = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      imageUrl: json['image_path'] ?? json['image_path'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? json['review_count'] ?? 0,
      category: json['category'] ?? '',
      categoryId: json['category_id'],
      bestSeller: json['best_seller'] == 1 || json['best_seller'] == true,
    );
  }

  factory Product.fromApiJson(Map<String, dynamic> json) {
    final rawImage = json['image_path'] ?? json['image_path'] ?? '';
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['original_price']?.toDouble(),
      imageUrl: AppConstants.getFullImageUrl(rawImage),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? json['reviewCount'] ?? 0,
      category: json['category']?['title'] ?? json['category_name'] ?? '',
      categoryId: json['category_id'] ?? json['category']?['id'],
      bestSeller: json['best_seller'] == 1 || json['best_seller'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'image_path': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'category_id': categoryId,
      'best_seller': bestSeller,
    };
  }
}
