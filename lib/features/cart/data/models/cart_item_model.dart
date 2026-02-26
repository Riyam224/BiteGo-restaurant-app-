class CartItemModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String category;
  final String? notes;

  CartItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.category,
    this.notes,
  });

  double get totalPrice => price * quantity;

  CartItemModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    String? category,
    String? notes,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
        'category': category,
        'notes': notes,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'] as String,
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String,
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
        category: json['category'] as String,
        notes: json['notes'] as String?,
      );
}
