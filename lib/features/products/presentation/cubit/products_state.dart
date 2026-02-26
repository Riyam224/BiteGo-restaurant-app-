import 'package:equatable/equatable.dart';
import 'package:restaurant_app/core/models/category_model.dart';
import 'package:restaurant_app/core/models/product_model.dart';

/// Products State
/// Immutable state for products feature
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

// ==================== INITIAL ====================
class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

// ==================== LOADING ====================
class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class CategoriesLoading extends ProductsState {
  const CategoriesLoading();
}

class ProductDetailsLoading extends ProductsState {
  const ProductDetailsLoading();
}

// ==================== SUCCESS ====================
class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  final bool hasMore;

  const ProductsLoaded({
    required this.products,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [products, hasMore];
}

class CategoriesLoaded extends ProductsState {
  final List<CategoryModel> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ProductDetailsLoaded extends ProductsState {
  final ProductModel product;

  const ProductDetailsLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

// ==================== ERROR ====================
class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoriesError extends ProductsState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductDetailsError extends ProductsState {
  final String message;

  const ProductDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
