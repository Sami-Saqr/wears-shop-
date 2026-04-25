import 'package:dio/dio.dart';

import '../core/network/api_constants.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Auth endpoints
  static Future<Response> login(String email, String password) async {
    final formData = FormData.fromMap({
      'email': email,
      'password': password,
    });
    return await _dio.post('login', data: formData);
  }

  static Future<Response> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final formData = FormData.fromMap({
      'name': fullName,
      'phone': phone,
      'email': email,
      'password': password,
    });
    return await _dio.post('register', data: formData);
  }

  static Future<Response> refreshToken(String refreshToken) async {
    _dio.options.headers['Authorization'] = 'Bearer $refreshToken';
    return await _dio.post('refresh_token');
  }

  static Future<Response> updateProfile({
    required String fullName,
    required String phone,
    String? avatar,
  }) async {
    final formData = FormData.fromMap({
      'name': fullName,
      'phone': phone,
      if (avatar != null) 'image_path': await MultipartFile.fromFile(avatar),
    });
    return await _dio.put('update_profile', data: formData);
  }

  static Future<Response> getUserData() async {
    return await _dio.get('get_user_data');
  }

  static Future<Response> deleteUser() async {
    return await _dio.delete('delete_user');
  }

  // Products endpoints
  static Future<Response> getProducts() async {
    return await _dio.get('products');
  }

  static Future<Response> searchProducts(String query) async {
    return await _dio.get('products/search', queryParameters: {'q': query});
  }

  static Future<Response> getBestSellerProducts() async {
    return await _dio.get('best_seller_products');
  }

  static Future<Response> getTopRatedProducts() async {
    return await _dio.get('top_rated_products');
  }

  static Future<Response> addToFavorite(int productId) async {
    final formData = FormData.fromMap({
      'product_id': productId,
    });
    return await _dio.post('add_to_favorite', data: formData);
  }

  // Categories endpoints
  static Future<Response> getCategories() async {
    return await _dio.get('categories');
  }

  // Orders endpoints
  static Future<Response> placeOrder(List<Map<String, dynamic>> items) async {
    return await _dio.post('place_order', data: {'items': items});
  }

  static Future<Response> getOrders() async {
    return await _dio.get('orders');
  }

  static Future<Response> cancelOrder(int orderId) async {
    return await _dio.post('orders/cancel/$orderId');
  }

  static Future<Response> completeOrder(int orderId) async {
    return await _dio.post('orders/complete/$orderId');
  }

  // Sliders endpoints
  static Future<Response> getSliders() async {
    return await _dio.get('sliders');
  }

  // Set auth token for authenticated requests
  static void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear auth token
  static void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}
