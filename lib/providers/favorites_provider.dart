import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favorites = [];
  bool _isLoading = false;

  List<Product> get favorites => List.unmodifiable(_favorites);
  int get count => _favorites.length;
  bool get isLoading => _isLoading;

  bool isFavorite(String productId) {
    return _favorites.any((product) => product.id == productId);
  }

  Future<bool> toggleFavorite(Product product) async {
    final index = _favorites.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      // Remove from favorites (local only - API doesn't have remove endpoint)
      _favorites.removeAt(index);
      notifyListeners();
      return true;
    } else {
      // Add to favorites via API
      _isLoading = true;
      notifyListeners();

      try {
        final response = await ApiService.addToFavorite(int.parse(product.id));

        if (response.statusCode == 200 || response.statusCode == 201) {
          _favorites.add(product);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          // Fallback: add locally if API fails
          _favorites.add(product);
          _isLoading = false;
          notifyListeners();
          return true;
        }
      } catch (e) {
        // Fallback: add locally if API fails
        _favorites.add(product);
        _isLoading = false;
        notifyListeners();
        debugPrint('Error adding to favorites: $e');
        return true;
      }
    }
  }

  void addToFavorites(Product product) {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
      notifyListeners();

      // Try to sync with API
      ApiService.addToFavorite(int.parse(product.id)).catchError((e) {
        debugPrint('Error syncing favorite to API: $e');
        return e;
      });
    }
  }

  void removeFromFavorites(String productId) {
    _favorites.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
