class OrderModel {
  final String id;
  final String orderNumber;
  final DateTime orderDate;
  final OrderStatus status;
  final double totalAmount;
  final List<OrderItem> items;
  final String deliveryAddress;
  final String? estimatedDeliveryTime;
  final String? trackingId;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.items,
    required this.deliveryAddress,
    this.estimatedDeliveryTime,
    this.trackingId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderNumber': orderNumber,
        'orderDate': orderDate.toIso8601String(),
        'status': status.name,
        'totalAmount': totalAmount,
        'items': items.map((item) => item.toJson()).toList(),
        'deliveryAddress': deliveryAddress,
        'estimatedDeliveryTime': estimatedDeliveryTime,
        'trackingId': trackingId,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        orderNumber: json['orderNumber'] as String,
        orderDate: DateTime.parse(json['orderDate'] as String),
        status: OrderStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => OrderStatus.pending,
        ),
        totalAmount: (json['totalAmount'] as num).toDouble(),
        items: (json['items'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList(),
        deliveryAddress: json['deliveryAddress'] as String,
        estimatedDeliveryTime: json['estimatedDeliveryTime'] as String?,
        trackingId: json['trackingId'] as String?,
      );
}

class OrderItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'] as String,
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String,
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
      );
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}
