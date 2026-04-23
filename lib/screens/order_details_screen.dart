import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import '../providers/orders_provider.dart';
import '../models/order.dart';
import '../widgets/checkout_item_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Order Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<OrdersProvider>(
        builder: (context, ordersProvider, child) {
          final order = ordersProvider.getOrderById(orderId);

          if (order == null) {
            return const Center(
              child: Text('Order not found'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order No. ${order.orderNumber}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd MMM, hh:mm a').format(order.orderDate),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              order.status == OrderStatus.active
                                  ? 'Active'
                                  : order.status == OrderStatus.completed
                                      ? 'Completed'
                                      : 'Cancelled',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: order.status == OrderStatus.active
                                    ? const Color(0xFF4392F9)
                                    : order.status == OrderStatus.completed
                                        ? Colors.green
                                        : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Order Items
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: order.items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = order.items[index];
                          return CheckoutItemCard(cartItem: item);
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Order Summary
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _buildSummaryRow('Subtotal', '\$ ${order.subtotal.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            _buildSummaryRow('Tax and Fees', '\$ ${order.taxAndFees.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            _buildSummaryRow('Delivery Fee', '\$ ${order.deliveryFee.toStringAsFixed(2)}'),
                            const Divider(height: 24),
                            _buildSummaryRow(
                              'Order Total',
                              '\$ ${order.total.toStringAsFixed(2)}',
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              
              // Action Buttons
              if (order.status == OrderStatus.active)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Cancel Order'),
                                content: const Text('Are you sure you want to cancel this order?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text(
                                      'Yes, Cancel',
                                      style: TextStyle(color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              await ordersProvider.cancelOrder(order.id);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            minimumSize: const Size(0, 50),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Cancel Order'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tracking driver...')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Track Driver'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.w600,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
