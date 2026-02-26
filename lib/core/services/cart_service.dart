import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/base_api_service.dart';
import 'package:restaurant_app/core/networking/endpoints.dart';

/// Service for cart-related API endpoints
/// Extends BaseApiService (requires authentication)
class CartService extends BaseApiService {
  /// Fetch the current user's cart
  ///
  /// Returns a Response containing cart details with items
  Future<Response> getCart() async {
    try {
      return await get(ApiEndpoints.cart);
    } catch (error) {
      rethrow;
    }
  }

  /// Add a product to the cart
  ///
  /// [productId] - Product ID to add
  /// [quantity] - Quantity to add (default: 1)
  /// [specialInstructions] - Optional special instructions
  ///
  /// Returns a Response containing updated cart
  Future<Response> addToCart({
    required int productId,
    required int quantity,
    String? specialInstructions,
  }) async {
    try {
      final data = <String, dynamic>{
        'product_id': productId,
        'quantity': quantity,
      };

      if (specialInstructions != null && specialInstructions.isNotEmpty) {
        data['special_instructions'] = specialInstructions;
      }

      return await post(
        ApiEndpoints.addToCart,
        data: data,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Remove an item from the cart
  ///
  /// [itemId] - Cart item ID (server-side ID)
  ///
  /// Returns a Response containing updated cart
  Future<Response> removeCartItem(int itemId) async {
    try {
      return await delete(ApiEndpoints.removeCartItem(itemId));
    } catch (error) {
      rethrow;
    }
  }

  /// Update cart item quantity
  ///
  /// [itemId] - Cart item ID (server-side ID)
  /// [quantity] - New quantity
  ///
  /// Returns a Response containing updated cart
  Future<Response> updateCartItem({
    required int itemId,
    required int quantity,
  }) async {
    try {
      return await put(
        ApiEndpoints.removeCartItem(itemId), // Using same endpoint with PUT method
        data: {
          'quantity': quantity,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Clear the entire cart
  ///
  /// Returns a Response confirming cart clearance
  Future<Response> clearCart() async {
    try {
      return await delete(ApiEndpoints.cart);
    } catch (error) {
      rethrow;
    }
  }

  /// Update special instructions for a cart item
  ///
  /// [itemId] - Cart item ID (server-side ID)
  /// [instructions] - Special instructions
  ///
  /// Returns a Response containing updated cart item
  Future<Response> updateCartItemInstructions({
    required int itemId,
    required String instructions,
  }) async {
    try {
      return await patch(
        ApiEndpoints.removeCartItem(itemId),
        data: {
          'special_instructions': instructions,
        },
      );
    } catch (error) {
      rethrow;
    }
  }
}
