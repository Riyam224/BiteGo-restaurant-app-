import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/booking/data/models/booking_model.dart';
import 'package:restaurant_app/features/booking/data/models/restaurant_detail_model.dart';
import 'package:restaurant_app/features/booking/presentation/widgets/details/other_restaurants_section.dart';
import 'package:restaurant_app/features/booking/presentation/widgets/details/restaurant_header_image.dart';
import 'package:restaurant_app/features/booking/presentation/widgets/details/restaurant_info_card.dart';
import 'package:restaurant_app/features/booking/presentation/widgets/booking_action_button.dart';
import 'package:restaurant_app/features/home/data/models/restaurant_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;
  final RestaurantDetailModel restaurant;

  const BookingDetailsScreen({
    super.key,
    required this.booking,
    required this.restaurant,
  });

  // Sample data for other restaurants
  List<RestaurantModel> get _otherRestaurants => [
        RestaurantModel(
          id: '1',
          name: 'Ambrosia Hotel',
          address: 'Kazi Deiry, Taiger Pass\nChittagong',
          imageUrl:
              'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg',
        ),
        RestaurantModel(
          id: '2',
          name: 'Tava Restaurant',
          address: 'Zakir Hossain Rd,\nChittagong',
          imageUrl:
              'https://images.pexels.com/photos/941861/pexels-photo-941861.jpeg',
        ),
        RestaurantModel(
          id: '3',
          name: 'Haatkhola',
          address: '6 Surson Road,\nChittagong',
          imageUrl:
              'https://images.pexels.com/photos/3201921/pexels-photo-3201921.jpeg',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.detailRestaurant,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textWhite,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Header Image
                  RestaurantHeaderImage(
                    imageUrl: restaurant.imageUrl,
                    restaurantName: restaurant.name,
                  ),

                  SizedBox(height: 16.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Restaurant Name
                        Text(
                          restaurant.name,
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.getTextPrimary(context),
                            fontSize: 22.sp,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Address
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16.sp,
                              color: AppColors.getTextSecondary(context),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                restaurant.address,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.getTextSecondary(context),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Restaurant Info Card (Open Status)
                        RestaurantInfoCard(
                          openStatus: restaurant.openStatus,
                          openingHours: restaurant.openingHours,
                          isOpenNow: restaurant.isOpenNow,
                        ),

                        SizedBox(height: 24.h),

                        // Other Restaurants Section
                        OtherRestaurantsSection(
                          restaurants: _otherRestaurants,
                          onRestaurantTap: (restaurant) {
                            debugPrint('Tapped on: ${restaurant.name}');
                          },
                          onSeeAllTap: () {
                            debugPrint('See All tapped');
                          },
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Booking Button at Bottom
          BookingActionButton(
            onPressed: () {
              debugPrint('Booking: ${restaurant.name}');
            },
          ),
        ],
      ),
    );
  }
}
