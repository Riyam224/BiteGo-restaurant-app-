import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/base_api_service.dart';
import 'package:restaurant_app/core/networking/endpoints.dart';

/// Service for product-related API endpoints
/// Extends BaseApiService (requires authentication)
class ProductService extends BaseApiService {
  /// Fetch all products with optional filters
  ///
  /// [categoryId] - Filter by category ID
  /// [search] - Search query for product name
  /// [minPrice] - Minimum price filter
  /// [maxPrice] - Maximum price filter
  /// [sortBy] - Sort order (price_asc, price_desc, name, newest)
  /// [page] - Page number (default: 1)
  /// [limit] - Items per page (default: 20)
  ///
  /// Returns a Response containing paginated product list
  Future<Response> getProducts({
    int? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (categoryId != null) queryParameters['category_id'] = categoryId;
      if (search != null && search.isNotEmpty) queryParameters['search'] = search;
      if (minPrice != null) queryParameters['min_price'] = minPrice;
      if (maxPrice != null) queryParameters['max_price'] = maxPrice;
      if (sortBy != null && sortBy.isNotEmpty) queryParameters['sort_by'] = sortBy;

      return await get(
        ApiEndpoints.products,
        queryParameters: queryParameters,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch a single product by ID
  ///
  /// [id] - Product ID
  ///
  /// Returns a Response containing product details
  Future<Response> getProductById(int id) async {
    try {
      return await get(ApiEndpoints.productDetails(id));
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch featured/special products
  /// This could be products with a specific tag or category
  ///
  /// [limit] - Number of featured products to fetch
  ///
  /// Returns a Response containing featured products
  Future<Response> getFeaturedProducts({int limit = 10}) async {
    try {
      return await get(
        ApiEndpoints.products,
        queryParameters: {
          'featured': true,
          'limit': limit,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch popular products (highest rated or most ordered)
  ///
  /// [limit] - Number of popular products to fetch
  ///
  /// Returns a Response containing popular products
  Future<Response> getPopularProducts({int limit = 10}) async {
    try {
      return await get(
        ApiEndpoints.products,
        queryParameters: {
          'sort_by': 'popular',
          'limit': limit,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch newest products
  ///
  /// [limit] - Number of newest products to fetch
  ///
  /// Returns a Response containing newest products
  Future<Response> getNewestProducts({int limit = 10}) async {
    try {
      return await get(
        ApiEndpoints.products,
        queryParameters: {
          'sort_by': 'newest',
          'limit': limit,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Search products by query
  ///
  /// [query] - Search query
  /// [page] - Page number
  /// [limit] - Items per page
  ///
  /// Returns a Response containing search results
  Future<Response> searchProducts({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await get(
        ApiEndpoints.products,
        queryParameters: {
          'search': query,
          'page': page,
          'limit': limit,
        },
      );
    } catch (error) {
      rethrow;
    }
  }
}
