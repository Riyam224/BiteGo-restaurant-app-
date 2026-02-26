/// Product model representing a food item in the restaurant
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final List<String> tags;
  final Map<String, dynamic>? nutritionInfo;
  final int? categoryId;
  final String? categoryName;
  final DateTime? createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isAvailable = true,
    this.tags = const [],
    this.nutritionInfo,
    this.categoryId,
    this.categoryName,
    this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    bool? isAvailable,
    List<String>? tags,
    Map<String, dynamic>? nutritionInfo,
    int? categoryId,
    String? categoryName,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isAvailable: isAvailable ?? this.isAvailable,
      tags: tags ?? this.tags,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
        'rating': rating,
        'reviewCount': reviewCount,
        'isAvailable': isAvailable,
        'tags': tags,
        'nutritionInfo': nutritionInfo,
        'categoryId': categoryId,
        'categoryName': categoryName,
        'createdAt': createdAt?.toIso8601String(),
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'].toString(), // Convert int to String for API compatibility
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String? ?? '',
        category: json['category'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: json['reviewCount'] as int? ?? json['review_count'] as int? ?? 0,
        isAvailable: json['isAvailable'] as bool? ?? json['is_available'] as bool? ?? true,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        nutritionInfo: json['nutritionInfo'] as Map<String, dynamic>? ?? json['nutrition_info'] as Map<String, dynamic>?,
        categoryId: json['categoryId'] as int? ?? json['category_id'] as int?,
        categoryName: json['categoryName'] as String? ?? json['category_name'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : null,
      );
}
