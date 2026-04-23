import 'package:flutter/material.dart';

class AppConstants {
  static const String baseUrl =
      'https://nti-ecommerce-api-production-f760.up.railway.app/api/';
  
  static const String storageBaseUrl =
      'https://nti-ecommerce-api-production-f760.up.railway.app/';

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
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$storageBaseUrl$cleanPath';
  }
}

class AppColors {
  static const Color primary = Color(0xFFF83758);
  static const Color primaryLight = Color(0xFFFFE4E9);
  static const Color secondary = Color(0xFF4392F9);
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF1D1D1D);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color textMuted = Color(0xFFBBBBBB);
  static const Color border = Color(0xFFE5E5E5);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color starColor = Color(0xFFEDB310);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle price = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle priceStrikethrough = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    decoration: TextDecoration.lineThrough,
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppBorderRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;
  static const double full = 100;
}
