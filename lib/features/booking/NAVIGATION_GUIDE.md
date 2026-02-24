# Booking Feature - Navigation Guide

## 📁 Folder Structure

```
lib/features/booking/
├── data/
│   └── models/
│       ├── booking_model.dart
│       └── restaurant_detail_model.dart
└── presentation/
    ├── screens/
    │   ├── booking_history_screen.dart      # Screen with green app bar
    │   └── booking_details_screen.dart      # Details screen with booking button
    └── widgets/
        ├── booking_history_card.dart        # Card in booking history list
        ├── booking_action_button.dart       # Bottom "Booking" button
        └── details/                         # Restaurant details widgets
            ├── other_restaurant_card.dart
            ├── other_restaurants_section.dart
            ├── restaurant_header_image.dart
            ├── restaurant_info_card.dart
            └── visit_restaurant_button.dart (removed - replaced with booking button)
```

## 🎯 How to Navigate

### From Booking History to Booking Details

```dart
// In booking_history_screen.dart
BookingHistoryCard(
  booking: booking,
  onTap: () {
    // Create restaurant detail model
    final restaurant = RestaurantDetailModel(
      id: booking.id,
      name: booking.restaurantName,
      address: 'Kazi Deiry, Taiger Pass\nChittagong',
      imageUrl: booking.imageUrl,
      openStatus: 'Open today',
      openingHours: '10:00 AM - 12:00 PM',
      isOpenNow: true,
      rating: 4.5,
      reviewCount: 120,
    );

    // Navigate to details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreen(
          booking: booking,
          restaurant: restaurant,
        ),
      ),
    );
  },
)
```

### From Home Screen to Booking Details

```dart
// When user taps on a restaurant card
void _navigateToBookingDetails(BuildContext context, RestaurantModel restaurant) {
  final restaurantDetail = RestaurantDetailModel(
    id: restaurant.id,
    name: restaurant.name,
    address: restaurant.address,
    imageUrl: restaurant.imageUrl,
    openStatus: 'Open today',
    openingHours: '10:00 AM - 12:00 PM',
    isOpenNow: true,
    rating: 4.5,
    reviewCount: 120,
  );

  // Create a temporary booking (or fetch from API)
  final booking = BookingModel(
    id: restaurant.id,
    restaurantName: restaurant.name,
    date: 'Today',
    time: '10:00 AM - 12:00 PM',
    status: 'Active',
    imageUrl: restaurant.imageUrl,
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BookingDetailsScreen(
        booking: booking,
        restaurant: restaurantDetail,
      ),
    ),
  );
}
```

## 🎨 Design Features

### Booking History Screen
- ✅ Green app bar with "Booking History" title
- ✅ No back button (accessed from bottom nav)
- ✅ List of booking cards with status badges
- ✅ Empty state when no bookings

### Booking Details Screen
- ✅ Green app bar with "Detail Restaurant" title and back button
- ✅ Restaurant header image (240h)
- ✅ Restaurant name and address
- ✅ Open status card with indicator (green/red)
- ✅ List of other restaurants with "Check" buttons
- ✅ Bottom booking button (fixed at bottom)
- ✅ Scrollable content area

## 🔧 Customization

### Change Open Status Colors
In `restaurant_info_card.dart`:
- Green (open): `AppColors.primary`
- Red (closed): `AppColors.error`

### Change Button Text
In `app_strings.dart`:
- `book` - "Book" (booking button)
- `check` - "Check" (other restaurant cards)
- `detailRestaurant` - "Detail Restaurant" (app bar)

### Modify Restaurant List
In `booking_details_screen.dart`:
```dart
List<RestaurantModel> get _otherRestaurants => [
  // Add or remove restaurants here
];
```

## ⚡ Widget Reusability

All widgets are modular and can be reused:
- `BookingActionButton` - Use anywhere for booking action
- `RestaurantHeaderImage` - Use for any restaurant image display
- `RestaurantInfoCard` - Show open/closed status anywhere
- `OtherRestaurantsSection` - List of restaurants with custom callbacks
- `OtherRestaurantCard` - Individual restaurant card

## 📝 Notes

- No hardcoded text (all from `app_strings.dart`)
- All sizes responsive (using `.sp`, `.w`, `.h`)
- Theme support (dark/light mode)
- Clean separation of widgets
- Easy to maintain and extend
