import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../utils/constants.dart';

class CheckoutItemCard extends StatelessWidget {
  final CartItem cartItem;

  const CheckoutItemCard({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
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
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          product.rating.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star,
                          color: AppColors.starColor,
                          size: 14,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${cartItem.quantity} item',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$ ${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '\$ ${product.originalPrice!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Total Order Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Order (${cartItem.quantity})  :',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                '\$ ${cartItem.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
