import 'package:dio/dio.dart';
import 'package:restaurant_app/core/models/category_model.dart';
import 'package:restaurant_app/core/models/product_model.dart';
import 'package:restaurant_app/core/networking/endpoints.dart';
import 'package:restaurant_app/core/networking/public_api_service.dart';

/// Products API Service
/// Handles all product-related API calls
/// Extends PublicApiService since product browsing is public
class ProductsService extends PublicApiService {
  ProductsService() : super();

  /// Get products with optional filters
  Future<List<ProductModel>> getProducts({
    String? search,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? page,
  }) async {
    try {
      final endpoint = ApiEndpoints.productsWithFilters(
        search: search,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
        page: page,
      );

      final response = await dio.get(endpoint);

      // API returns paginated response with 'results' array
      final List<dynamic> results = response.data['results'] ?? [];
      return results.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get single product details
  Future<ProductModel> getProductDetails(String productId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.productDetails(int.parse(productId)),
      );

      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(ApiEndpoints.categories);

      // API returns paginated response with 'results' array
      final List<dynamic> results = response.data['results'] ?? [];
      return results.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get product rating statistics
  Future<Map<String, dynamic>> getProductRatings(String productId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.productRatings(int.parse(productId)),
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ??
                        error.response?.data['detail'] ??
                        'Something went wrong';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled');
      default:
        return Exception('Network error. Please try again.');
    }
  }
}
