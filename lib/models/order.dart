import 'cart_item.dart';

enum OrderStatus { active, completed, cancelled }

class Order {
  final String id;
  final String orderNumber;
  final List<CartItem> items;
  final double subtotal;
  final double taxAndFees;
  final double deliveryFee;
  final DateTime orderDate;
  final OrderStatus status;
  final String? deliveryAddress;

  Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.taxAndFees,
    required this.deliveryFee,
    required this.orderDate,
    required this.status,
    this.deliveryAddress,
  });

  double get total => subtotal + taxAndFees + deliveryFee;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  String get statusText {
    switch (status) {
      case OrderStatus.active:
        return 'Active';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Order Canceled';
    }
  }

  Order copyWith({
    String? id,
    String? orderNumber,
    List<CartItem>? items,
    double? subtotal,
    double? taxAndFees,
    double? deliveryFee,
    DateTime? orderDate,
    OrderStatus? status,
    String? deliveryAddress,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAndFees: taxAndFees ?? this.taxAndFees,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }
}
