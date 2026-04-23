import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../utils/constants.dart';
import '../widgets/category_item.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerPage = 0;

  @override
  void initState() {
    super.initState();
    // Load data from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsProvider>().loadAllData();
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ProductsProvider>(
          builder: (context, productsProvider, child) {
            if (productsProvider.isLoading && productsProvider.products.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (productsProvider.error != null && productsProvider.products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load data',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => productsProvider.loadAllData(),
                      child: const Text('Retry'),
                    ),
                  ],
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

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SearchBarWidget(
                        onTap: () {
                          Navigator.pushNamed(context, '/search');
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

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
                            return CategoryItem(
                              category: CategoryItemData(
                                id: category.id.toString(),
                                name: category.name,
                                imageUrl: category.imageUrl,
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Promo Banner / Sliders
                    if (productsProvider.sliders.isNotEmpty)
                      SizedBox(
                        height: 180,
                        child: PageView.builder(
                          controller: _bannerController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentBannerPage = index;
                            });
                          },
                          itemCount: productsProvider.sliders.length,
                          itemBuilder: (context, index) {
                            final slider = productsProvider.sliders[index];
                            return PromoBanner(
                              title: slider.title,
                              subtitle: slider.description,
                              description: '',
                              buttonText: 'Shop Now',
                              imageUrl: slider.imageUrl,
                            );
                          },
                        ),
                      )
                    else
                      SizedBox(
                        height: 180,
                        child: PageView(
                          controller: _bannerController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentBannerPage = index;
                            });
                          },
                          children: const [
                            PromoBanner(
                              title: '50-40% OFF',
                              subtitle: 'Now in (product)',
                              description: 'All colours',
                              buttonText: 'Shop Now',
                            ),
                            PromoBanner(
                              title: 'New Arrivals',
                              subtitle: 'Summer Collection',
                              description: 'Limited time',
                              buttonText: 'Shop Now',
                            ),
                            PromoBanner(
                              title: 'Flash Sale',
                              subtitle: 'Up to 70% OFF',
                              description: 'Today only',
                              buttonText: 'Shop Now',
                            ),
                          ],
                        ),
                      ),

                    // Page Indicator
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        productsProvider.sliders.isNotEmpty
                            ? productsProvider.sliders.length
                            : 3,
                        (index) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentBannerPage == index
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Best Seller Section
                    if (productsProvider.bestSellerProducts.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Best Sellers',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to all best sellers
                              },
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 260,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: productsProvider.bestSellerProducts.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final product =
                                productsProvider.bestSellerProducts[index];
                            return SizedBox(
                              width: 160,
                              child: ProductCard(product: product),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Recommended Section
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Recommended',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Products Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: productsProvider.products.isEmpty
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
                                      'No products available',
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
                              itemCount: productsProvider.products.length,
                              itemBuilder: (context, index) {
                                final product = productsProvider.products[index];
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
