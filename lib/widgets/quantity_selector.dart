import 'package:flutter/material.dart';
import '../utils/constants.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.remove,
              color: AppColors.primary,
              size: 18,
            ),
          ),
        ),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text(
            quantity.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
