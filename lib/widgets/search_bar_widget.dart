import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const SearchBarWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey.shade400,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Search any Product..',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
