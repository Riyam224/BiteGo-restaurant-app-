import 'package:flutter/foundation.dart';
import 'package:restaurant_app/core/models/category_model.dart';
import 'package:restaurant_app/core/networking/api_error_handler.dart';
import 'package:restaurant_app/core/services/category_service.dart';

/// Provider for managing category state
/// Uses ChangeNotifier pattern for state management
class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService;

  CategoryProvider(this._categoryService);

  // State
  List<CategoryModel> _categories = [];
  CategoryModel? _selectedCategory;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  // Getters
  List<CategoryModel> get categories => List.unmodifiable(_categories);
  CategoryModel? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  /// Fetch all categories from API
  Future<void> fetchCategories({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _categories.clear();
      _hasMore = true;
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _categoryService.getCategories(
        page: _currentPage,
        limit: 20,
      );

      final List<dynamic> results = response.data['results'] ?? response.data['data'] ?? [];

      final newCategories = results
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      if (refresh) {
        _categories = newCategories;
      } else {
        _categories.addAll(newCategories);
      }

      // Check if there are more pages
      _hasMore = newCategories.length >= 20;
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

  /// Fetch a single category by ID
  Future<CategoryModel?> fetchCategoryById(int id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _categoryService.getCategoryById(id);
      final category = CategoryModel.fromJson(response.data as Map<String, dynamic>);

      _isLoading = false;
      notifyListeners();

      return category;
    } catch (error) {
      _isLoading = false;
      _error = ApiErrorHandler.handleError(error);
      notifyListeners();
      rethrow;
    }
  }

  /// Select a category
  void selectCategory(CategoryModel? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Clear selected category
  void clearSelectedCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh categories (pull to refresh)
  Future<void> refresh() async {
    await fetchCategories(refresh: true);
  }

  /// Load more categories (pagination)
  Future<void> loadMore() async {
    if (!_isLoading && _hasMore) {
      await fetchCategories();
    }
  }

  /// Get category by ID from local cache
  CategoryModel? getCategoryById(int id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search categories by name (local search)
  List<CategoryModel> searchCategories(String query) {
    if (query.isEmpty) return _categories;

    return _categories
        .where((category) =>
            category.name.toLowerCase().contains(query.toLowerCase()) ||
            (category.description?.toLowerCase().contains(query.toLowerCase()) ?? false))
        .toList();
  }

  @override
  void dispose() {
    _categories.clear();
    super.dispose();
  }
}
