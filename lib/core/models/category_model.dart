/// Category model representing a food category from the API
class CategoryModel {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int productsCount;
  final DateTime? createdAt;

  const CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.productsCount = 0,
    this.createdAt,
  });

  CategoryModel copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    int? productsCount,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      productsCount: productsCount ?? this.productsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'products_count': productsCount,
        'created_at': createdAt?.toIso8601String(),
      };

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
        imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
        productsCount: json['products_count'] as int? ?? json['productsCount'] as int? ?? 0,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
      );

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, productsCount: $productsCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.productsCount == productsCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        imageUrl.hashCode ^
        productsCount.hashCode;
  }
}
