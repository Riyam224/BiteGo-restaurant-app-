import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/base_api_service.dart';
import 'package:restaurant_app/core/networking/endpoints.dart';

/// Service for category-related API endpoints
/// Extends BaseApiService (requires authentication)
class CategoryService extends BaseApiService {
  /// Fetch all categories with pagination
  ///
  /// [page] - Page number (default: 1)
  /// [limit] - Items per page (default: 20)
  ///
  /// Returns a Response containing paginated category list
  Future<Response> getCategories({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await get(
        ApiEndpoints.categories,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch a single category by ID
  ///
  /// [id] - Category ID
  ///
  /// Returns a Response containing category details
  Future<Response> getCategoryById(int id) async {
    try {
      return await get('${ApiEndpoints.categories}/$id');
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch products in a specific category
  ///
  /// [categoryId] - Category ID to filter products
  /// [page] - Page number (default: 1)
  /// [limit] - Items per page (default: 20)
  ///
  /// Returns a Response containing paginated products
  Future<Response> getCategoryProducts({
    required int categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await get(
        ApiEndpoints.products,
        queryParameters: {
          'category_id': categoryId,
          'page': page,
          'limit': limit,
        },
      );
    } catch (error) {
      rethrow;
    }
  }
}
