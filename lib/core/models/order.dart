import 'cart_item.dart';

/// Complete order model
class Order {
  final String id;
  final String orderNumber;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final OrderStatus status;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryTime;
  final String? driverName;
  final String? driverPhone;
  final String? driverImage;
  final double? driverRating;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    this.deliveryInstructions,
    required this.paymentMethod,
    required this.createdAt,
    this.estimatedDeliveryTime,
    this.driverName,
    this.driverPhone,
    this.driverImage,
    this.driverRating,
  });

  Order copyWith({
    String? id,
    String? orderNumber,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    OrderStatus? status,
    String? deliveryAddress,
    String? deliveryInstructions,
    PaymentMethod? paymentMethod,
    DateTime? createdAt,
    DateTime? estimatedDeliveryTime,
    String? driverName,
    String? driverPhone,
    String? driverImage,
    double? driverRating,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverImage: driverImage ?? this.driverImage,
      driverRating: driverRating ?? this.driverRating,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderNumber': orderNumber,
        'items': items.map((item) => item.toJson()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'tax': tax,
        'total': total,
        'status': status.name,
        'deliveryAddress': deliveryAddress,
        'deliveryInstructions': deliveryInstructions,
        'paymentMethod': paymentMethod.name,
        'createdAt': createdAt.toIso8601String(),
        'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
        'driverName': driverName,
        'driverPhone': driverPhone,
        'driverImage': driverImage,
        'driverRating': driverRating,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        orderNumber: json['orderNumber'] as String,
        items: (json['items'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList(),
        subtotal: (json['subtotal'] as num).toDouble(),
        deliveryFee: (json['deliveryFee'] as num).toDouble(),
        tax: (json['tax'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
        status: OrderStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => OrderStatus.pending,
        ),
        deliveryAddress: json['deliveryAddress'] as String,
        deliveryInstructions: json['deliveryInstructions'] as String?,
        paymentMethod: PaymentMethod.values.firstWhere(
          (e) => e.name == json['paymentMethod'],
          orElse: () => PaymentMethod.cash,
        ),
        createdAt: DateTime.parse(json['createdAt'] as String),
        estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
            ? DateTime.parse(json['estimatedDeliveryTime'] as String)
            : null,
        driverName: json['driverName'] as String?,
        driverPhone: json['driverPhone'] as String?,
        driverImage: json['driverImage'] as String?,
        driverRating: (json['driverRating'] as num?)?.toDouble(),
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

enum PaymentMethod {
  cash,
  card,
  applePay,
  googlePay,
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

  String get description {
    switch (this) {
      case OrderStatus.pending:
        return 'Waiting for restaurant confirmation';
      case OrderStatus.confirmed:
        return 'Your order has been confirmed';
      case OrderStatus.preparing:
        return 'Restaurant is preparing your food';
      case OrderStatus.outForDelivery:
        return 'Driver is on the way';
      case OrderStatus.delivered:
        return 'Delivered successfully';
      case OrderStatus.cancelled:
        return 'Order was cancelled';
    }
  }
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash on Delivery';
      case PaymentMethod.card:
        return 'Credit/Debit Card';
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.googlePay:
        return 'Google Pay';
    }
  }
}
