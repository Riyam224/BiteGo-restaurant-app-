import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:restaurant_app/features/products/domain/usecases/get_product_details_usecase.dart';
import 'package:restaurant_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:restaurant_app/features/products/presentation/cubit/products_state.dart';

/// Products Cubit
/// Manages products, categories, and product details state
class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductsCubit({
    required this.getProductsUseCase,
    required this.getCategoriesUseCase,
    required this.getProductDetailsUseCase,
  }) : super(const ProductsInitial());

  // ==================== GET PRODUCTS ====================

  /// Load products with optional filters
  Future<void> loadProducts({
    String? search,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? page,
  }) async {
    emit(const ProductsLoading());

    final result = await getProductsUseCase(
      search: search,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortBy: sortBy,
      page: page,
    );

    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(
        products: products,
        hasMore: products.length >= 10, // Assuming 10 items per page
      )),
    );
  }

  /// Refresh products (pull to refresh)
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  /// Search products
  Future<void> searchProducts(String query) async {
    await loadProducts(search: query);
  }

  /// Filter by category
  Future<void> filterByCategory(int categoryId) async {
    await loadProducts(categoryId: categoryId);
  }

  /// Filter by price range
  Future<void> filterByPrice({double? minPrice, double? maxPrice}) async {
    await loadProducts(minPrice: minPrice, maxPrice: maxPrice);
  }

  /// Sort products
  Future<void> sortProducts(String sortBy) async {
    await loadProducts(sortBy: sortBy);
  }

  // ==================== GET CATEGORIES ====================

  /// Load all categories
  Future<void> loadCategories() async {
    emit(const CategoriesLoading());

    final result = await getCategoriesUseCase();

    result.fold(
      (failure) => emit(CategoriesError(failure.message)),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }

  // ==================== GET PRODUCT DETAILS ====================

  /// Load single product details
  Future<void> loadProductDetails(String productId) async {
    emit(const ProductDetailsLoading());

    final result = await getProductDetailsUseCase(productId);

    result.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (product) => emit(ProductDetailsLoaded(product)),
    );
  }

  // ==================== RESET ====================

  /// Reset to initial state
  void reset() {
    emit(const ProductsInitial());
  }
}
