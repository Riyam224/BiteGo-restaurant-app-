/// Cart response model representing the server-side cart structure
class CartResponse {
  final List<CartItemResponse> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final int itemsCount;

  const CartResponse({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.itemsCount,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        items: (json['items'] as List<dynamic>?)
                ?.map((item) => CartItemResponse.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
        deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ??
                     (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
        tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
        total: (json['total'] as num?)?.toDouble() ?? 0.0,
        itemsCount: json['items_count'] as int? ??
                    json['itemsCount'] as int? ??
                    (json['items'] as List<dynamic>?)?.length ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'items': items.map((item) => item.toJson()).toList(),
        'subtotal': subtotal,
        'delivery_fee': deliveryFee,
        'tax': tax,
        'total': total,
        'items_count': itemsCount,
      };

  @override
  String toString() {
    return 'CartResponse(itemsCount: $itemsCount, total: $total)';
  }
}

/// Individual cart item from the server
class CartItemResponse {
  final int id; // Server cart item ID
  final int productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final String? specialInstructions;
  final String? category;
  final bool? isAvailable;

  const CartItemResponse({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    this.specialInstructions,
    this.category,
    this.isAvailable,
  });

  double get totalPrice => price * quantity;

  factory CartItemResponse.fromJson(Map<String, dynamic> json) => CartItemResponse(
        id: json['id'] as int,
        productId: json['product_id'] as int? ?? json['productId'] as int,
        productName: json['product_name'] as String? ?? json['productName'] as String,
        productImage: json['product_image'] as String? ??
                     json['productImage'] as String? ??
                     json['image_url'] as String?,
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
        specialInstructions: json['special_instructions'] as String? ??
                            json['specialInstructions'] as String?,
        category: json['category'] as String?,
        isAvailable: json['is_available'] as bool? ??
                    json['isAvailable'] as bool? ??
                    true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'product_name': productName,
        'product_image': productImage,
        'price': price,
        'quantity': quantity,
        'special_instructions': specialInstructions,
        'category': category,
        'is_available': isAvailable,
      };

  @override
  String toString() {
    return 'CartItemResponse(id: $id, productName: $productName, quantity: $quantity, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItemResponse &&
        other.id == id &&
        other.productId == productId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^ productId.hashCode ^ quantity.hashCode;
  }
}
