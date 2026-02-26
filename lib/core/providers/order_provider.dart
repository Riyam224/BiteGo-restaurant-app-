import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

/// Order management provider
class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  Order? _currentOrder;

  List<Order> get orders => List.unmodifiable(_orders);
  Order? get currentOrder => _currentOrder;

  List<Order> get activeOrders => _orders
      .where((order) =>
          order.status != OrderStatus.delivered &&
          order.status != OrderStatus.cancelled)
      .toList();

  List<Order> get pastOrders => _orders
      .where((order) =>
          order.status == OrderStatus.delivered ||
          order.status == OrderStatus.cancelled)
      .toList();

  /// Create new order from cart
  Future<Order> createOrder({
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double tax,
    required double total,
    required String deliveryAddress,
    String? deliveryInstructions,
    required PaymentMethod paymentMethod,
  }) async {
    // Generate order number (in production, this would come from backend)
    final orderNumber =
        'ORD-${DateTime.now().year}-${_orders.length + 1001}';

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNumber: orderNumber,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
      status: OrderStatus.pending,
      deliveryAddress: deliveryAddress,
      deliveryInstructions: deliveryInstructions,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 30)),
    );

    _orders.insert(0, order);
    _currentOrder = order;
    notifyListeners();

    // Simulate order processing (replace with actual API call)
    _simulateOrderProcessing(order.id);

    return order;
  }

  /// Simulate order status changes (replace with real-time updates from backend)
  void _simulateOrderProcessing(String orderId) {
    Future.delayed(const Duration(seconds: 3), () {
      updateOrderStatus(orderId, OrderStatus.confirmed);

      Future.delayed(const Duration(seconds: 5), () {
        updateOrderStatus(orderId, OrderStatus.preparing);

        Future.delayed(const Duration(seconds: 10), () {
          final order = _orders.firstWhere((o) => o.id == orderId);
          updateOrder(
            orderId,
            order.copyWith(
              status: OrderStatus.outForDelivery,
              driverName: 'John Doe',
              driverPhone: '+1234567890',
              driverImage: 'https://i.pravatar.cc/150?img=6',
              driverRating: 4.8,
            ),
          );
        });
      });
    });
  }

  /// Update order status
  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: status);
      if (_currentOrder?.id == orderId) {
        _currentOrder = _orders[index];
      }
      notifyListeners();
    }
  }

  /// Update entire order
  void updateOrder(String orderId, Order updatedOrder) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index >= 0) {
      _orders[index] = updatedOrder;
      if (_currentOrder?.id == orderId) {
        _currentOrder = updatedOrder;
      }
      notifyListeners();
    }
  }

  /// Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (_) {
      return null;
    }
  }

  /// Cancel order
  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  /// Clear current order
  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }

  /// Mark order as delivered
  void markAsDelivered(String orderId) {
    updateOrderStatus(orderId, OrderStatus.delivered);
  }
}
