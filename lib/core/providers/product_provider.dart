import 'package:flutter/foundation.dart';
import 'package:restaurant_app/core/models/product_model.dart';
import 'package:restaurant_app/core/networking/api_error_handler.dart';
import 'package:restaurant_app/core/services/product_service.dart';

/// Provider for managing product state with filtering and search
/// Uses ChangeNotifier pattern for state management
class ProductProvider extends ChangeNotifier {
  final ProductService _productService;

  ProductProvider(this._productService);

  // State
  List<ProductModel> _products = [];
  List<ProductModel> _featuredProducts = [];
  List<ProductModel> _popularProducts = [];
  ProductModel? _selectedProduct;
  bool _isLoading = false;
  bool _isFeaturedLoading = false;
  bool _isPopularLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  // Filter state
  int? _selectedCategoryId;
  String? _searchQuery;
  double? _minPrice;
  double? _maxPrice;
  String? _sortBy;

  // Getters
  List<ProductModel> get products => List.unmodifiable(_products);
  List<ProductModel> get featuredProducts => List.unmodifiable(_featuredProducts);
  List<ProductModel> get popularProducts => List.unmodifiable(_popularProducts);
  ProductModel? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  bool get isFeaturedLoading => _isFeaturedLoading;
  bool get isPopularLoading => _isPopularLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  int? get selectedCategoryId => _selectedCategoryId;
  String? get searchQuery => _searchQuery;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  String? get sortBy => _sortBy;

  /// Fetch products with current filters
  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _products.clear();
      _hasMore = true;
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _productService.getProducts(
        categoryId: _selectedCategoryId,
        search: _searchQuery,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        sortBy: _sortBy,
        page: _currentPage,
        limit: 20,
      );

      final List<dynamic> results = response.data['results'] ?? response.data['data'] ?? [];

      final newProducts = results
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (refresh) {
        _products = newProducts;
      } else {
        _products.addAll(newProducts);
      }

      _hasMore = newProducts.length >= 20;
      _currentPage++;

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = ApiErrorHandler.handleError(error);
      notifyListeners();
      rethrow;
    }
  }

  /// Fetch product by ID
  Future<ProductModel?> fetchProductById(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _productService.getProductById(id);
      final product = ProductModel.fromJson(response.data as Map<String, dynamic>);

      _selectedProduct = product;
      _isLoading = false;
      notifyListeners();

      return product;
    } catch (error) {
      _isLoading = false;
      _error = ApiErrorHandler.handleError(error);
      notifyListeners();
      rethrow;
    }
  }

  /// Fetch featured products (Today's Specials)
  Future<void> fetchFeaturedProducts({int limit = 10}) async {
    _isFeaturedLoading = true;
    notifyListeners();

    try {
      final response = await _productService.getNewestProducts(limit: limit);

      final List<dynamic> results = response.data['results'] ?? response.data['data'] ?? [];

      _featuredProducts = results
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _isFeaturedLoading = false;
      notifyListeners();
    } catch (error) {
      _isFeaturedLoading = false;
      _error = ApiErrorHandler.handleError(error);
      notifyListeners();
    }
  }

  /// Fetch popular products (Popular Menu)
  Future<void> fetchPopularProducts({int limit = 10}) async {
    _isPopularLoading = true;
    notifyListeners();

    try {
      final response = await _productService.getPopularProducts(limit: limit);

      final List<dynamic> results = response.data['results'] ?? response.data['data'] ?? [];

      _popularProducts = results
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _isPopularLoading = false;
      notifyListeners();
    } catch (error) {
      _isPopularLoading = false;
      _error = ApiErrorHandler.handleError(error);
      notifyListeners();
    }
  }

  /// Set filter parameters
  void setFilter({
    int? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
  }) {
    _selectedCategoryId = categoryId;
    _searchQuery = search;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _sortBy = sortBy;

    // Reset pagination
    _currentPage = 1;
    _products.clear();
    _hasMore = true;

    notifyListeners();

    // Fetch with new filters
    fetchProducts();
  }

  /// Update only category filter
  void setCategoryFilter(int? categoryId) {
    setFilter(
      categoryId: categoryId,
      search: _searchQuery,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      sortBy: _sortBy,
    );
  }

  /// Update only search query
  void setSearchQuery(String? query) {
    setFilter(
      categoryId: _selectedCategoryId,
      search: query,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      sortBy: _sortBy,
    );
  }

  /// Update price range
  void setPriceRange({double? minPrice, double? maxPrice}) {
    setFilter(
      categoryId: _selectedCategoryId,
      search: _searchQuery,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortBy: _sortBy,
    );
  }

  /// Update sort order
  void setSortBy(String? sortBy) {
    setFilter(
      categoryId: _selectedCategoryId,
      search: _searchQuery,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      sortBy: sortBy,
    );
  }

  /// Clear all filters
  void clearFilters() {
    _selectedCategoryId = null;
    _searchQuery = null;
    _minPrice = null;
    _maxPrice = null;
    _sortBy = null;
    _currentPage = 1;
    _products.clear();
    _hasMore = true;

    notifyListeners();

    fetchProducts();
  }

  /// Select a product
  void selectProduct(ProductModel? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  /// Clear selected product
  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh products (pull to refresh)
  Future<void> refresh() async {
    await fetchProducts(refresh: true);
  }

  /// Load more products (pagination)
  Future<void> loadMore() async {
    if (!_isLoading && _hasMore) {
      await fetchProducts();
    }
  }

  /// Get product by ID from local cache
  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if product is in featured list
  bool isFeatured(String productId) {
    return _featuredProducts.any((p) => p.id == productId);
  }

  /// Check if product is in popular list
  bool isPopular(String productId) {
    return _popularProducts.any((p) => p.id == productId);
  }

  @override
  void dispose() {
    _products.clear();
    _featuredProducts.clear();
    _popularProducts.clear();
    super.dispose();
  }
}
