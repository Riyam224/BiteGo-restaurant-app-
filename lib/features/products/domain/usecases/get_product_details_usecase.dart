import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/error/failures.dart';
import 'package:restaurant_app/core/models/product_model.dart';
import 'package:restaurant_app/features/products/domain/repositories/products_repository.dart';

/// Use Case for getting product details
class GetProductDetailsUseCase {
  final ProductsRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Either<Failure, ProductModel>> call(String productId) async {
    return await repository.getProductDetails(productId);
  }
}
