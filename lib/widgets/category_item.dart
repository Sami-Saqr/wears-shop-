import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CategoryItemData {
  final String id;
  final String name;
  final String imageUrl;

  CategoryItemData({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class CategoryItem extends StatelessWidget {
  final dynamic category;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.category,
    this.isSelected = false,
  });

  String get _name {
    if (category is CategoryItemData) {
      return (category as CategoryItemData).name;
    }
    return category.name ?? '';
  }

  String get _imageUrl {
    if (category is CategoryItemData) {
      return (category as CategoryItemData).imageUrl;
    }
    return category.imageUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade100,
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: ClipOval(
            child: _imageUrl.isNotEmpty
                ? Image.network(
                    _imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.category,
                          color: Colors.grey.shade400,
                          size: 24,
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.category,
                      color: Colors.grey.shade400,
                      size: 24,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
