import 'package:flutter/foundation.dart';

import '../core/network/api_constants.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class Slider {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  Slider({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Slider.fromJson(Map<String, dynamic> json) {
    final rawImage = json['image_path'] ?? json['image_path'] ?? '';
    return Slider(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: ApiConstants.getFullImageUrl(rawImage),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final rawImage = json['image_path'] ?? json['image_path'] ?? '';
    return Category(
      id: json['id'] ?? 0,
      name: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: ApiConstants.getFullImageUrl(rawImage),
    );
  }
}

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _bestSellerProducts = [];
  List<Product> _topRatedProducts = [];
  List<Category> _categories = [];
  List<Slider> _sliders = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => List.unmodifiable(_products);
  List<Product> get bestSellerProducts => List.unmodifiable(_bestSellerProducts);
  List<Product> get topRatedProducts => List.unmodifiable(_topRatedProducts);
  List<Category> get categories => List.unmodifiable(_categories);
  List<Slider> get sliders => List.unmodifiable(_sliders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getProducts();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          _products = data.map((json) => Product.fromApiJson(json)).toList();
        } else if (data is Map && data['products'] is List) {
          _products = (data['products'] as List)
              .map((json) => Product.fromApiJson(json))
              .toList();
        }
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      _error = 'Error loading products: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBestSellerProducts() async {
    try {
      final response = await ApiService.getBestSellerProducts();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          _bestSellerProducts =
              data.map((json) => Product.fromApiJson(json)).toList();
        } else if (data is Map && data['products'] is List) {
          _bestSellerProducts = (data['products'] as List)
              .map((json) => Product.fromApiJson(json))
              .toList();
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading best seller products: $e');
    }
  }

  Future<void> loadTopRatedProducts() async {
    try {
      final response = await ApiService.getTopRatedProducts();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          _topRatedProducts =
              data.map((json) => Product.fromApiJson(json)).toList();
        } else if (data is Map && data['products'] is List) {
          _topRatedProducts = (data['products'] as List)
              .map((json) => Product.fromApiJson(json))
              .toList();
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading top rated products: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return _products;

    try {
      final response = await ApiService.searchProducts(query);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => Product.fromApiJson(json)).toList();
        } else if (data is Map && data['products'] is List) {
          return (data['products'] as List)
              .map((json) => Product.fromApiJson(json))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Error searching products: $e');
    }

    // Fallback to local search
    final lowerQuery = query.toLowerCase();
    return _products
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            p.description.toLowerCase().contains(lowerQuery))
        .toList();
  }

  Future<void> loadCategories() async {
    try {
      final response = await ApiService.getCategories();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          _categories = data.map((json) => Category.fromJson(json)).toList();
        } else if (data is Map && data['categories'] is List) {
          _categories = (data['categories'] as List)
              .map((json) => Category.fromJson(json))
              .toList();
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> loadSliders() async {
    try {
      final response = await ApiService.getSliders();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          _sliders = data.map((json) => Slider.fromJson(json)).toList();
        } else if (data is Map && data['sliders'] is List) {
          _sliders = (data['sliders'] as List)
              .map((json) => Slider.fromJson(json))
              .toList();
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading sliders: $e');
    }
  }

  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      loadProducts(),
      loadCategories(),
      loadSliders(),
      loadBestSellerProducts(),
      loadTopRatedProducts(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  List<Product> getProductsByCategory(int categoryId) {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
