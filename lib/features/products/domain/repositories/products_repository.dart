import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/error/failures.dart';
import 'package:restaurant_app/core/models/category_model.dart';
import 'package:restaurant_app/core/models/product_model.dart';

/// Products Repository Interface
/// Following Dependency Inversion Principle - high-level module depends on abstraction
abstract class ProductsRepository {
  /// Get all products with optional filters
  Future<Either<Failure, List<ProductModel>>> getProducts({
    String? search,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? page,
  });

  /// Get single product details by ID
  Future<Either<Failure, ProductModel>> getProductDetails(String productId);

  /// Get all categories
  Future<Either<Failure, List<CategoryModel>>> getCategories();

  /// Get product rating statistics
  Future<Either<Failure, Map<String, dynamic>>> getProductRatings(
    String productId,
  );
}
