import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/base_api_service.dart';
import 'package:restaurant_app/core/networking/endpoints.dart';

/// Service for order-related API endpoints
/// Extends BaseApiService (requires authentication)
class OrderService extends BaseApiService {
  /// Create a new order from the current cart
  ///
  /// [addressId] - Delivery address ID
  /// [couponCode] - Optional coupon code for discount
  /// [paymentMethod] - Payment method (cash, card, etc.)
  /// [deliveryInstructions] - Optional delivery instructions
  ///
  /// Returns a Response containing created order details
  Future<Response> createOrder({
    required int addressId,
    String? couponCode,
    String? paymentMethod,
    String? deliveryInstructions,
  }) async {
    try {
      final data = <String, dynamic>{
        'address_id': addressId,
      };

      if (couponCode != null && couponCode.isNotEmpty) {
        data['coupon_code'] = couponCode;
      }

      if (paymentMethod != null && paymentMethod.isNotEmpty) {
        data['payment_method'] = paymentMethod;
      }

      if (deliveryInstructions != null && deliveryInstructions.isNotEmpty) {
        data['delivery_instructions'] = deliveryInstructions;
      }

      return await post(
        ApiEndpoints.createOrder,
        data: data,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch all orders for the current user
  ///
  /// [page] - Page number (default: 1)
  /// [limit] - Items per page (default: 20)
  /// [status] - Filter by order status (pending, confirmed, etc.)
  ///
  /// Returns a Response containing paginated order list
  Future<Response> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      return await get(
        ApiEndpoints.orders,
        queryParameters: queryParameters,
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch a single order by ID
  ///
  /// [id] - Order ID
  ///
  /// Returns a Response containing order details
  Future<Response> getOrderById(int id) async {
    try {
      return await get(ApiEndpoints.orderDetails(id));
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch real-time order status
  ///
  /// [id] - Order ID
  ///
  /// Returns a Response containing current order status with driver info
  Future<Response> getOrderStatus(int id) async {
    try {
      return await get(ApiEndpoints.orderStatus(id));
    } catch (error) {
      rethrow;
    }
  }

  /// Cancel an order
  ///
  /// [id] - Order ID
  /// [reason] - Optional cancellation reason
  ///
  /// Returns a Response confirming cancellation
  Future<Response> cancelOrder({
    required int id,
    String? reason,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (reason != null && reason.isNotEmpty) {
        data['reason'] = reason;
      }

      return await patch(
        ApiEndpoints.orderStatus(id),
        data: {
          'status': 'cancelled',
          ...data,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Confirm order delivery (mark as received)
  ///
  /// [id] - Order ID
  ///
  /// Returns a Response confirming delivery
  Future<Response> confirmDelivery(int id) async {
    try {
      return await patch(
        ApiEndpoints.orderStatus(id),
        data: {
          'status': 'delivered',
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch active orders (not completed or cancelled)
  ///
  /// [page] - Page number
  /// [limit] - Items per page
  ///
  /// Returns a Response containing active orders
  Future<Response> getActiveOrders({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await get(
        ApiEndpoints.orders,
        queryParameters: {
          'page': page,
          'limit': limit,
          'active': true,
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  /// Fetch order history (completed or cancelled)
  ///
  /// [page] - Page number
  /// [limit] - Items per page
  ///
  /// Returns a Response containing past orders
  Future<Response> getOrderHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await get(
        ApiEndpoints.orders,
        queryParameters: {
          'page': page,
          'limit': limit,
          'active': false,
        },
      );
    } catch (error) {
      rethrow;
    }
  }
}
