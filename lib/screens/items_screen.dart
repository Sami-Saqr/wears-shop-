import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../utils/constants.dart';
import '../widgets/category_item.dart';
import '../widgets/product_card.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Load data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductsProvider>();
      if (provider.products.isEmpty) {
        provider.loadAllData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ProductsProvider>(
          builder: (context, productsProvider, child) {
            final filteredProducts = _selectedCategoryId == null
                ? productsProvider.products
                : productsProvider.getProductsByCategory(_selectedCategoryId!);

            if (productsProvider.isLoading && productsProvider.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => productsProvider.loadAllData(),
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Logo
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFF83758), Color(0xFF3B5998)],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.trending_up,
                                  color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Stylish',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3B5998),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Categories Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'All Featured',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Category List
                    if (productsProvider.categories.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: productsProvider.categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 20),
                          itemBuilder: (context, index) {
                            final category = productsProvider.categories[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedCategoryId == category.id) {
                                    _selectedCategoryId = null;
                                  } else {
                                    _selectedCategoryId = category.id;
                                  }
                                });
                              },
                              child: CategoryItem(
                                category: CategoryItemData(
                                  id: category.id.toString(),
                                  name: category.name,
                                  imageUrl: category.imageUrl,
                                ),
                                isSelected: _selectedCategoryId == category.id,
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Products Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedCategoryId != null
                                ? productsProvider.categories
                                        .firstWhere(
                                          (c) => c.id == _selectedCategoryId,
                                          orElse: () => productsProvider.categories.first,
                                        )
                                        .name
                                : 'All Products',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${filteredProducts.length} Items',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Products Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: filteredProducts.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No products in this category',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.58,
                              ),
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                return ProductCard(product: product);
                              },
                            ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
