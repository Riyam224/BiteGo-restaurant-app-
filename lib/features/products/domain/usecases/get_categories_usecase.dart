import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/error/failures.dart';
import 'package:restaurant_app/core/models/category_model.dart';
import 'package:restaurant_app/features/products/domain/repositories/products_repository.dart';

/// Use Case for getting categories
class GetCategoriesUseCase {
  final ProductsRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<CategoryModel>>> call() async {
    return await repository.getCategories();
  }
}
