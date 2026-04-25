import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_helper.dart';
import '../models/user_model.dart';

class AuthRepo {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioHelper.postData(
        endpoint: ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
        useFormData: true,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': response.data['access_token'],
          'message': 'Login successful',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Login failed',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioHelper.postData(
        endpoint: ApiConstants.register,
        data: {
          'name': fullName,
          'phone': phone,
          'email': email,
          'password': password,
        },
        useFormData: true,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        UserModel? user;
        
        if (data['user'] != null) {
          user = UserModel.fromJson(data['user']);
        }

        return {
          'success': true,
          'token': data['access_token'],
          'user': user,
          'message': 'Registration successful',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Registration failed',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final response = await DioHelper.getData(
        endpoint: ApiConstants.getUserData,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String phone,
    String? avatarPath,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': fullName,
        'phone': phone,
      };

      if (avatarPath != null) {
        data['image_path'] = await MultipartFile.fromFile(avatarPath);
      }

      final response = await DioHelper.putData(
        endpoint: ApiConstants.updateProfile,
        data: data,
        useFormData: true,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
          'message': 'Profile updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Update failed',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _handleDioError(e),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'];
        if (statusCode == 401) {
          return 'Invalid credentials';
        } else if (statusCode == 422) {
          // Handle validation errors
          final errors = e.response?.data?['errors'];
          if (errors != null && errors is Map) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            }
          }
          return message ?? 'Validation error';
        } else if (statusCode == 409) {
          return 'Email already exists';
        }
        return message ?? 'Server error occurred';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'An unexpected error occurred';
    }
  }
}
