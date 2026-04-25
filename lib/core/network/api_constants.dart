class ApiConstants {
  static const String baseUrl =
      'https://nti-ecommerce-api-production-f760.up.railway.app/api/';

  static const String storageBaseUrl =
      'https://nti-ecommerce-api-production-f760.up.railway.app/';

  // Auth endpoints
  static const String login = 'login';
  static const String register = 'register';
  static const String refreshToken = 'refresh_token';
  static const String getUserData = 'get_user_data';
  static const String updateProfile = 'update_profile';
  static const String deleteUser = 'delete_user';

  // Products endpoints
  static const String products = 'products';
  static const String searchProducts = 'products/search';
  static const String bestSellerProducts = 'best_seller_products';
  static const String topRatedProducts = 'top_rated_products';
  static const String addToFavorite = 'add_to_favorite';

  // Categories endpoints
  static const String categories = 'categories';

  // Orders endpoints
  static const String placeOrder = 'place_order';
  static const String orders = 'orders';

  // Sliders endpoints
  static const String sliders = 'sliders';

  /// Builds full image URL from relative path
  static String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }
    // If already a full URL, return as is
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    // Remove leading slash if present
    final cleanPath =
        imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$storageBaseUrl$cleanPath';
  }
}
