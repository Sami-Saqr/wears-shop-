import 'package:flutter/material.dart';

import '../../features/auth/views/login/login_screen.dart';
import '../../features/auth/views/register/register_screen.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/profile/views/settings/settings_screen.dart';
import '../../features/profile/views/update_profile/edit_profile_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/welcome/welcome_screen.dart';
import '../../screens/cart_screen.dart';
import '../../screens/checkout_screen.dart';
import '../../screens/favorites_screen.dart';
import '../../screens/items_screen.dart';
import '../../screens/main_navigation_screen.dart';
import '../../screens/my_orders_screen.dart';
import '../../screens/order_details_screen.dart';
import '../../screens/product_detail_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/search_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String myOrders = '/my-orders';
  static const String favorites = '/favorites';
  static const String productDetail = '/product-detail';
  static const String orderDetails = '/order-details';
  static const String items = '/items';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case AppRoutes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.myOrders:
        return MaterialPageRoute(builder: (_) => const MyOrdersScreen());
      case AppRoutes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case AppRoutes.items:
        return MaterialPageRoute(builder: (_) => const ItemsScreen());
      case AppRoutes.productDetail:
        final productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );
      case AppRoutes.orderDetails:
        final orderId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(orderId: orderId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
