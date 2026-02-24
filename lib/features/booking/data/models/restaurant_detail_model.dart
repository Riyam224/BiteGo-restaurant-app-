class RestaurantDetailModel {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final String openStatus;
  final String openingHours;
  final bool isOpenNow;
  final double rating;
  final int reviewCount;

  RestaurantDetailModel({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.openStatus,
    required this.openingHours,
    required this.isOpenNow,
    required this.rating,
    required this.reviewCount,
  });
}
