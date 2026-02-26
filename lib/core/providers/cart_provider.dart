import 'package:flutter/foundation.dart';
import 'package:restaurant_app/core/models/cart_item.dart';
import 'package:restaurant_app/core/models/cart_response.dart';
import 'package:restaurant_app/core/models/product_model.dart';
import 'package:restaurant_app/core/networking/api_error_handler.dart';
import 'package:restaurant_app/core/services/cart_service.dart';

/// Cart state management following SOLID principles
/// Now with API synchronization support
class CartProvider extends ChangeNotifier {
  final CartService? _cartService;
  final List<CartItem> _items = [];

  // State
  bool _isLoading = false;
  String? _error;
  bool _isSynced = false;

  // Pricing (can be overridden from API)
  double _deliveryFee = 3.99;
  double _taxRate = 0.1;
  double? _apiSubtotal;
  double? _apiTotal;

  CartProvider([this._cartService]);

  // Getters
  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSynced => _isSynced;
  double get deliveryFee => _deliveryFee;
  double get taxRate => _taxRate;

  // Price calculations (prefer API values if available)
  double get subtotal =>
      _apiSubtotal ?? _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * _taxRate;

  double get total => _apiTotal ?? (subtotal + _deliveryFee + tax);

  /// Add product to cart
  void addItem(ProductModel product, {int quantity = 1, String? specialInstructions}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Update existing item quantity
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
        specialInstructions: specialInstructions,
      );
    } else {
      // Add new item
      _items.add(CartItem(
        product: product,
        quantity: quantity,
        specialInstructions: specialInstructions,
        addedAt: DateTime.now(),
      ));
    }

    notifyListeners();
  }

  /// Remove item from cart
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Update item quantity
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  /// Update special instructions
  void updateInstructions(String productId, String instructions) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(specialInstructions: instructions);
      notifyListeners();
    }
  }

  /// Clear entire cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Get item by product ID
  CartItem? getItem(String productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (_) {
      return null;
    }
  }

  /// Check if product is in cart
  bool hasProduct(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Get quantity for a specific product
  int getQuantity(String productId) {
    final item = getItem(productId);
    return item?.quantity ?? 0;
  }

  // ==================== API SYNC METHODS ====================

  /// Sync cart with server (fetch cart from API)
  Future<void> syncCart() async {
    if (_cartService == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _cartService!.getCart();
      final cartResponse = CartResponse.fromJson(response.data as Map<String, dynamic>);

      // Update pricing from API
      _deliveryFee = cartResponse.deliveryFee;
      _apiSubtotal = cartResponse.subtotal;
      _apiTotal = cartResponse.total;

      // Convert API cart items to local cart items
      _items.clear();
      for (final apiItem in cartResponse.items) {
        // Create ProductModel from API response
        final product = ProductModel(
          id: apiItem.productId.toString(),
          name: apiItem.productName,
          description: '',
          price: apiItem.price,
          imageUrl: apiItem.productImage ?? '',
          category: apiItem.category ?? '',
        );

        _items.add(CartItem(
          product: product,
          quantity: apiItem.quantity,
          specialInstructions: apiItem.specialInstructions,
          addedAt: DateTime.now(),
        ));
      }

      _isSynced = true;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = ApiErrorHandler.handleError(error);
      _isSynced = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Add item to cart with API sync
  Future<void> addItemWithSync(
    ProductModel product, {
    int quantity = 1,
    String? specialInstructions,
  }) async {
    if (_cartService == null) {
      // Fallback to local-only mode
      addItem(product, quantity: quantity, specialInstructions: specialInstructions);
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Convert String ID to int for API
      final productId = int.parse(product.id);

      final response = await _cartService!.addToCart(
        productId: productId,
        quantity: quantity,
        specialInstructions: specialInstructions,
      );

      // Sync cart from response
      final cartResponse = CartResponse.fromJson(response.data as Map<String, dynamic>);

      // Update local cart from API response
      _deliveryFee = cartResponse.deliveryFee;
      _apiSubtotal = cartResponse.subtotal;
      _apiTotal = cartResponse.total;

      // Add or update local item
      addItem(product, quantity: quantity, specialInstructions: specialInstructions);

      _isSynced = true;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = ApiErrorHandler.handleError(error);
      notifyListeners();
      rethrow;
    }
  }

  /// Remove item from cart with API sync
  Future<void> removeItemWithSync(String productId, int? serverId) async {
    if (_cartService == null || serverId == null) {
      // Fallback to local-only mode
      removeItem(productId);
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _cartService!.removeCartItem(serverId);

      // Remove from local cart
      removeItem(productId);

      _isSynced = true;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = ApiErrorHandler.handleError(error);
      notifyListeners();
      rethrow;
    }
  }

  /// Update quantity with API sync
  Future<void> updateQuantityWithSync(
    String productId,
    int newQuantity,
    int? serverId,
  ) async {
    if (_cartService == null || serverId == null) {
      // Fallback to local-only mode
      updateQuantity(productId, newQuantity);
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _cartService!.updateCartItem(
        itemId: serverId,
        quantity: newQuantity,
      );

      // Update local cart
      updateQuantity(productId, newQuantity);

      _isSynced = true;
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = ApiErrorHandler.handleError(error);
      notifyListeners();
      rethrow;
    }
  }

  /// Clear cart with API sync
  Future<void> clearCartWithSync() async {
    if (_cartService == null) {
      // Fallback to local-only mode
      clear();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _cartService!.clearCart();

      // Clear local cart
      clear();

      _isSynced = true;
      _isLoading = false;
      _apiSubtotal = null;
      _apiTotal = null;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = ApiErrorHandler.handleError(error);
      notifyListeners();
      rethrow;
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
