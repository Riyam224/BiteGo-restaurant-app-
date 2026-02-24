class BookingModel {
  final String id;
  final String restaurantName;
  final String date;
  final String time;
  final String status;
  final String imageUrl;

  BookingModel({
    required this.id,
    required this.restaurantName,
    required this.date,
    required this.time,
    required this.status,
    required this.imageUrl,
  });
}
