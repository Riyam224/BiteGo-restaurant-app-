import '../../models/product_model.dart';
import '../../models/order.dart';

/// AI-powered recommendation service
/// In production, this would connect to an AI/ML service or API
class AIRecommendationService {
  /// Get personalized recommendations based on order history
  Future<List<ProductModel>> getPersonalizedRecommendations({
    required List<Order> orderHistory,
    required List<ProductModel> availableProducts,
    int limit = 5,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (orderHistory.isEmpty) {
      // For new users, return popular items
      return _getPopularItems(availableProducts, limit);
    }

    // Analyze user's order history
    final userPreferences = _analyzeUserPreferences(orderHistory);

    // Filter and sort products based on preferences
    final recommendations = availableProducts.where((product) {
      return userPreferences.preferredCategories.contains(product.category);
    }).toList();

    recommendations.sort((a, b) => b.rating.compareTo(a.rating));

    return recommendations.take(limit).toList();
  }

  /// Get AI-powered food pairings
  Future<List<ProductModel>> getFoodPairings({
    required ProductModel selectedProduct,
    required List<ProductModel> availableProducts,
    int limit = 3,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Simple pairing logic (in production, use ML model)
    final pairings = <ProductModel>[];

    for (final product in availableProducts) {
      if (product.id == selectedProduct.id) continue;

      // Pair desserts with beverages
      if (selectedProduct.category == 'Desserts' &&
          product.category == 'Beverages') {
        pairings.add(product);
      }
      // Pair main courses with salads
      else if (selectedProduct.category == 'Main Course' &&
          product.category == 'Salads') {
        pairings.add(product);
      }
      // Pair fast food with beverages
      else if (selectedProduct.category == 'Fast Food' &&
          product.category == 'Beverages') {
        pairings.add(product);
      }
    }

    return pairings.take(limit).toList();
  }

  /// Get trending items based on ratings and reviews
  Future<List<ProductModel>> getTrendingItems({
    required List<ProductModel> availableProducts,
    int limit = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final trending = List<ProductModel>.from(availableProducts);
    trending.sort((a, b) {
      final scoreA = a.rating * a.reviewCount;
      final scoreB = b.rating * b.reviewCount;
      return scoreB.compareTo(scoreA);
    });

    return trending.take(limit).toList();
  }

  /// Get dietary recommendations
  Future<List<ProductModel>> getDietaryRecommendations({
    required List<String> dietaryPreferences,
    required List<ProductModel> availableProducts,
    int limit = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final recommendations = availableProducts.where((product) {
      return product.tags.any((tag) => dietaryPreferences.contains(tag));
    }).toList();

    return recommendations.take(limit).toList();
  }

  /// Private: Get popular items
  List<ProductModel> _getPopularItems(
    List<ProductModel> products,
    int limit,
  ) {
    final popular = List<ProductModel>.from(products);
    popular.sort((a, b) => b.rating.compareTo(a.rating));
    return popular.take(limit).toList();
  }

  /// Private: Analyze user preferences from order history
  _UserPreferences _analyzeUserPreferences(List<Order> orderHistory) {
    final categoryCount = <String, int>{};

    for (final order in orderHistory) {
      for (final item in order.items) {
        final category = item.product.category;
        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }
    }

    final sortedCategories = categoryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return _UserPreferences(
      preferredCategories: sortedCategories.map((e) => e.key).toList(),
    );
  }
}

class _UserPreferences {
  final List<String> preferredCategories;

  _UserPreferences({required this.preferredCategories});
}
