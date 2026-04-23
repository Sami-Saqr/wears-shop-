import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../utils/constants.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onTrackDriver;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onCancel,
    this.onTrackDriver,
  });

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final product = firstItem?.product;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: product != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
            
            const SizedBox(width: 16),
            
            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product?.name ?? 'Order #${order.orderNumber}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '\$ ${order.total.toInt()}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy h:mm a').format(order.orderDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        '${order.totalItems} item',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Status or Action Buttons
                  if (order.status == OrderStatus.active)
                    Row(
                      children: [
                        if (onCancel != null)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: onCancel,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        if (onCancel != null && onTrackDriver != null)
                          const SizedBox(width: 12),
                        if (onTrackDriver != null)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onTrackDriver,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              child: const Text(
                                'Track Driver',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Icon(
                          order.status == OrderStatus.completed
                              ? Icons.check_circle_outline
                              : Icons.cancel_outlined,
                          color: order.status == OrderStatus.completed
                              ? Colors.green
                              : AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order.status == OrderStatus.completed
                              ? 'Order delivered'
                              : 'Order Canceled',
                          style: TextStyle(
                            fontSize: 13,
                            color: order.status == OrderStatus.completed
                                ? Colors.green
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
