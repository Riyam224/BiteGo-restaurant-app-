import 'product_model.dart';

/// Cart item with product and quantity
class CartItem {
  final ProductModel product;
  final int quantity;
  final String? specialInstructions;
  final DateTime addedAt;

  const CartItem({
    required this.product,
    required this.quantity,
    this.specialInstructions,
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    ProductModel? product,
    int? quantity,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'specialInstructions': specialInstructions,
        'addedAt': addedAt.toIso8601String(),
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
        quantity: json['quantity'] as int,
        specialInstructions: json['specialInstructions'] as String?,
        addedAt: DateTime.parse(json['addedAt'] as String),
      );
}
