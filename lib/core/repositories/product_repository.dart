import '../models/product_model.dart';

/// Product repository - handles data fetching
/// Replace with actual API calls in production
class ProductRepository {
  // Singleton pattern
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;
  ProductRepository._internal();

  /// Sample product data - replace with API calls
  List<ProductModel> getAllProducts() {
    return [
      const ProductModel(
        id: '1',
        name: 'Chicken Biryani',
        description: 'Aromatic basmati rice layered with tender chicken, fragrant spices, and herbs. Served with raita.',
        price: 18.99,
        imageUrl: 'https://images.pexels.com/photos/20642812/pexels-photo-20642812.jpeg',
        category: 'Main Course',
        rating: 4.5,
        reviewCount: 62,
        isAvailable: true,
        tags: ['spicy', 'popular', 'non-veg'],
      ),
      const ProductModel(
        id: '2',
        name: 'Margherita Pizza',
        description: 'Classic Italian pizza with fresh mozzarella, tomato sauce, and basil on a crispy thin crust.',
        price: 14.99,
        imageUrl: 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg',
        category: 'Italian',
        rating: 4.7,
        reviewCount: 48,
        isAvailable: true,
        tags: ['vegetarian', 'popular', 'italian'],
      ),
      const ProductModel(
        id: '3',
        name: 'Beef Burger',
        description: 'Juicy beef patty with lettuce, tomato, onions, pickles, and our special sauce in a toasted bun.',
        price: 15.99,
        imageUrl: 'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg',
        category: 'Fast Food',
        rating: 4.3,
        reviewCount: 35,
        isAvailable: true,
        tags: ['non-veg', 'american'],
      ),
      const ProductModel(
        id: '4',
        name: 'Caesar Salad',
        description: 'Crisp romaine lettuce with Caesar dressing, croutons, parmesan cheese, and optional grilled chicken.',
        price: 12.99,
        imageUrl: 'https://images.pexels.com/photos/1059905/pexels-photo-1059905.jpeg',
        category: 'Salads',
        rating: 4.6,
        reviewCount: 28,
        isAvailable: true,
        tags: ['vegetarian', 'healthy', 'low-carb'],
      ),
      const ProductModel(
        id: '5',
        name: 'Grilled Salmon',
        description: 'Fresh Atlantic salmon fillet grilled to perfection with herbs, lemon, and garlic butter.',
        price: 24.99,
        imageUrl: 'https://images.pexels.com/photos/1516415/pexels-photo-1516415.jpeg',
        category: 'Seafood',
        rating: 4.8,
        reviewCount: 45,
        isAvailable: true,
        tags: ['non-veg', 'healthy', 'gluten-free', 'premium'],
      ),
      const ProductModel(
        id: '6',
        name: 'Chocolate Lava Cake',
        description: 'Warm chocolate cake with a molten chocolate center, served with vanilla ice cream.',
        price: 8.99,
        imageUrl: 'https://images.pexels.com/photos/291528/pexels-photo-291528.jpeg',
        category: 'Desserts',
        rating: 4.9,
        reviewCount: 72,
        isAvailable: true,
        tags: ['vegetarian', 'dessert', 'popular'],
      ),
      const ProductModel(
        id: '7',
        name: 'Sushi Platter',
        description: 'Assorted fresh sushi rolls including California rolls, salmon nigiri, and tuna maki.',
        price: 32.99,
        imageUrl: 'https://images.pexels.com/photos/357756/pexels-photo-357756.jpeg',
        category: 'Asian',
        rating: 4.7,
        reviewCount: 38,
        isAvailable: true,
        tags: ['non-veg', 'japanese', 'premium'],
      ),
      const ProductModel(
        id: '8',
        name: 'Pasta Carbonara',
        description: 'Creamy pasta with pancetta, egg, parmesan cheese, and black pepper.',
        price: 16.99,
        imageUrl: 'https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg',
        category: 'Italian',
        rating: 4.6,
        reviewCount: 42,
        isAvailable: true,
        tags: ['non-veg', 'italian'],
      ),
      const ProductModel(
        id: '9',
        name: 'Fresh Orange Juice',
        description: 'Freshly squeezed orange juice, no added sugar or preservatives.',
        price: 5.99,
        imageUrl: 'https://images.pexels.com/photos/1337824/pexels-photo-1337824.jpeg',
        category: 'Beverages',
        rating: 4.4,
        reviewCount: 25,
        isAvailable: true,
        tags: ['vegetarian', 'vegan', 'healthy'],
      ),
      const ProductModel(
        id: '10',
        name: 'Greek Yogurt Bowl',
        description: 'Thick Greek yogurt topped with fresh berries, honey, and granola.',
        price: 9.99,
        imageUrl: 'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg',
        category: 'Breakfast',
        rating: 4.5,
        reviewCount: 31,
        isAvailable: true,
        tags: ['vegetarian', 'healthy', 'breakfast'],
      ),
    ];
  }

  /// Get products by category
  List<ProductModel> getProductsByCategory(String category) {
    return getAllProducts()
        .where((product) => product.category == category)
        .toList();
  }

  /// Get product by ID
  ProductModel? getProductById(String id) {
    try {
      return getAllProducts().firstWhere((product) => product.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Search products
  List<ProductModel> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return getAllProducts().where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery) ||
          product.category.toLowerCase().contains(lowerQuery) ||
          product.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Get trending products
  List<ProductModel> getTrendingProducts({int limit = 5}) {
    final products = getAllProducts();
    products.sort((a, b) {
      final scoreA = a.rating * a.reviewCount;
      final scoreB = b.rating * b.reviewCount;
      return scoreB.compareTo(scoreA);
    });
    return products.take(limit).toList();
  }
}
