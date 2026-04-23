import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class OrdersProvider with ChangeNotifier {
  final List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;

  List<Order> get activeOrders =>
      _orders.where((o) => o.status == OrderStatus.active).toList();

  List<Order> get completedOrders =>
      _orders.where((o) => o.status == OrderStatus.completed).toList();

  List<Order> get cancelledOrders =>
      _orders.where((o) => o.status == OrderStatus.cancelled).toList();

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Order?> placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double taxAndFees,
    required double deliveryFee,
    String? deliveryAddress,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final orderItems = items
          .map((item) => {
                'product_id': int.parse(item.product.id),
                'quantity': item.quantity,
              })
          .toList();

      final response = await ApiService.placeOrder(orderItems);

      if (response.statusCode == 201) {
        final data = response.data;

        final order = Order(
          id: data['id'].toString(),
          orderNumber: data['order_number'] ?? 'Order #${data['id']}',
          items: items,
          subtotal: subtotal,
          taxAndFees: taxAndFees,
          deliveryFee: deliveryFee,
          orderDate: DateTime.now(),
          status: OrderStatus.active,
          deliveryAddress: deliveryAddress,
        );

        _orders.insert(0, order);
        _isLoading = false;
        notifyListeners();
        return order;
      } else {
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    _isLoading = true;
    notifyListeners();

    // Update locally first for better UX
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: OrderStatus.cancelled);
    }

    try {
      final response = await ApiService.cancelOrder(int.parse(orderId));

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        // API failed but local update is still applied
        _isLoading = false;
        notifyListeners();
        return true; // Return true since local update succeeded
      }
    } catch (e) {
      // API failed but local update is still applied
      _isLoading = false;
      notifyListeners();
      return true; // Return true since local update succeeded
    }
  }

  Future<bool> completeOrder(String orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.completeOrder(int.parse(orderId));

      if (response.statusCode == 200) {
        final index = _orders.indexWhere((order) => order.id == orderId);
        if (index >= 0) {
          _orders[index] =
              _orders[index].copyWith(status: OrderStatus.completed);
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getOrders();

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          _orders.clear();
          for (var orderData in data) {
            // Parse items from API response
            List<CartItem> items = [];
            if (orderData['items'] is List) {
              for (var itemData in orderData['items']) {
                try {
                  // Assuming API returns product details in items
                  final productData = itemData['product'] ?? itemData;
                  final product = Product(
                    id: productData['id'].toString(),
                    name: productData['name'] ?? 'Unknown Product',
                    description: productData['description'] ?? '',
                    price: (productData['price'] ?? 0).toDouble(),
                    originalPrice: productData['original_price']?.toDouble(),
                    imageUrl:
                        productData['image_path'] ?? productData['image_path'] ?? '',
                    rating: (productData['rating'] ?? 0).toDouble(),
                    reviewCount: productData['review_count'] ?? 0,
                    category: productData['category'] ?? '',
                  );

                  final cartItem = CartItem(
                    product: product,
                    quantity: itemData['quantity'] ?? 1,
                  );
                  items.add(cartItem);
                } catch (e) {
                  // Skip invalid items
                  continue;
                }
              }
            }

            final order = Order(
              id: orderData['id'].toString(),
              orderNumber:
                  orderData['order_number'] ?? 'Order #${orderData['id']}',
              items: items,
              subtotal: (orderData['subtotal'] ?? 0).toDouble(),
              taxAndFees: (orderData['tax_and_fees'] ?? 0).toDouble(),
              deliveryFee: (orderData['delivery_fee'] ?? 0).toDouble(),
              orderDate: DateTime.parse(
                  orderData['order_date'] ?? DateTime.now().toIso8601String()),
              status: _parseOrderStatus(orderData['status']),
              deliveryAddress: orderData['delivery_address'],
            );
            _orders.add(order);
          }
        }
      }
    } catch (e) {
      // Handle error - could show error message to user
      debugPrint('Error loading orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  OrderStatus _parseOrderStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return OrderStatus.active;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.active;
    }
  }
}
