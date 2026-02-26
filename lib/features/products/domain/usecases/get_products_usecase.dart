import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/error/failures.dart';
import 'package:restaurant_app/core/models/product_model.dart';
import 'package:restaurant_app/features/products/domain/repositories/products_repository.dart';

/// Use Case for getting products list
/// Following Single Responsibility Principle
class GetProductsUseCase {
  final ProductsRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductModel>>> call({
    String? search,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? page,
  }) async {
    return await repository.getProducts(
      search: search,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortBy: sortBy,
      page: page,
    );
  }
}
