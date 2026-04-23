import '../models/product.dart';
// import '../models/category.dart';

class MockData {
  static List<Category> get categories => [
    Category(
      id: 'beauty',
      name: 'Beauty',
      imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=100&h=100&fit=crop',
    ),
    Category(
      id: 'fashion',
      name: 'Fashion',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=100&h=100&fit=crop',
    ),
    Category(
      id: 'kids',
      name: 'Kids',
      imageUrl: 'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=100&h=100&fit=crop',
    ),
    Category(
      id: 'mens',
      name: 'Mens',
      imageUrl: 'https://images.unsplash.com/photo-1617137968427-85924c800a22?w=100&h=100&fit=crop',
    ),
    Category(
      id: 'womens',
      name: 'Womens',
      imageUrl: 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=100&h=100&fit=crop',
    ),
  ];

  static List<Product> get products => [
    Product(
      id: '1',
      name: 'Mens Starry',
      description: 'Vision Alta Men\'s Shoes Size (All Colours) Mens Starry Sky Printed Shirt 100% Cotton Fabric',
      price: 399,
      imageUrl: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/10-Iw5KaBLGSUWFv101iZMb10XuQ7LVfk.png',
      rating: 4.5,
      reviewCount: 152344,
      category: 'mens',
    ),
    Product(
      id: '2',
      name: 'Mens Starry',
      description: 'Mens Starry Sky Printed Shirt 100% Cotton Fabric',
      price: 399,
      imageUrl: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/10-Iw5KaBLGSUWFv101iZMb10XuQ7LVfk.png',
      rating: 4.5,
      reviewCount: 152344,
      category: 'mens',
    ),
    Product(
      id: '3',
      name: "Women's Casual Wear",
      description: 'Beautiful casual wear for women, perfect for everyday style',
      price: 34.00,
      originalPrice: 64.00,
      imageUrl: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/12-yYOWHJqwHCg9iGIDP3AZLWl60G3xUD.png',
      rating: 4.8,
      reviewCount: 2456,
      category: 'womens',
    ),
    Product(
      id: '4',
      name: "Men's Jacket",
      description: 'Stylish men\'s jacket for casual and formal occasions',
      price: 45.00,
      originalPrice: 67.00,
      imageUrl: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/12-yYOWHJqwHCg9iGIDP3AZLWl60G3xUD.png',
      rating: 4.7,
      reviewCount: 1823,
      category: 'mens',
    ),
    Product(
      id: '5',
      name: 'Mens Starry Sky Shirt',
      description: 'Premium cotton shirt with starry sky print',
      price: 50.00,
      imageUrl: 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/10-Iw5KaBLGSUWFv101iZMb10XuQ7LVfk.png',
      rating: 4.6,
      reviewCount: 98234,
      category: 'mens',
    ),
    Product(
      id: '6',
      name: 'Casual Summer Dress',
      description: 'Light and comfortable summer dress for women',
      price: 55.00,
      originalPrice: 80.00,
      imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&h=500&fit=crop',
      rating: 4.9,
      reviewCount: 3421,
      category: 'womens',
    ),
  ];

  static List<Product> getProductsByCategory(String categoryId) {
    return products.where((p) => p.category == categoryId).toList();
  }

  static List<Product> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return products.where((p) =>
      p.name.toLowerCase().contains(lowerQuery) ||
      p.description.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  static Product? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}

class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
