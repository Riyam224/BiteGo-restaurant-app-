import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/error/failures.dart';
import 'package:restaurant_app/core/models/category_model.dart';
import 'package:restaurant_app/core/models/product_model.dart';
import 'package:restaurant_app/features/products/data/services/products_service.dart';
import 'package:restaurant_app/features/products/domain/repositories/products_repository.dart';

/// Products Repository Implementation
/// Implements the repository interface with actual API calls
class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsService _service;

  ProductsRepositoryImpl(this._service);

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts({
    String? search,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? page,
  }) async {
    try {
      final products = await _service.getProducts(
        search: search,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
        page: page,
      );
      return Right(products);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductDetails(
    String productId,
  ) async {
    try {
      final product = await _service.getProductDetails(productId);
      return Right(product);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await _service.getCategories();
      return Right(categories);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getProductRatings(
    String productId,
  ) async {
    try {
      final ratings = await _service.getProductRatings(productId);
      return Right(ratings);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
