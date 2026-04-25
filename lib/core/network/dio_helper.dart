import 'package:dio/dio.dart';

import '../cache/cache_helper.dart';
import 'api_constants.dart';

class DioHelper {
  static Dio? _dio;

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor for logging and token handling
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = CacheHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  static Future<Response> getData({
    required String endpoint,
    Map<String, dynamic>? query,
  }) async {
    return await _dio!.get(endpoint, queryParameters: query);
  }

  static Future<Response> postData({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    bool useFormData = false,
  }) async {
    final requestData = useFormData && data != null ? FormData.fromMap(data) : data;
    return await _dio!.post(endpoint, data: requestData, queryParameters: query);
  }

  static Future<Response> putData({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    bool useFormData = false,
  }) async {
    final requestData = useFormData && data != null ? FormData.fromMap(data) : data;
    return await _dio!.put(endpoint, data: requestData, queryParameters: query);
  }

  static Future<Response> deleteData({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    return await _dio!.delete(endpoint, data: data, queryParameters: query);
  }

  static void setAuthToken(String token) {
    _dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearAuthToken() {
    _dio?.options.headers.remove('Authorization');
  }
}
