class NewArrivalModel {
  final String id;
  final String name;
  final String restaurantName;
  final String imageUrl;
  final int reviewCount;
  final double? rating;

  NewArrivalModel({
    required this.id,
    required this.name,
    required this.restaurantName,
    required this.imageUrl,
    required this.reviewCount,
    this.rating,
  });
}
