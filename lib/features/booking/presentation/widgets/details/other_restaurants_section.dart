import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/booking/presentation/widgets/details/other_restaurant_card.dart';
import 'package:restaurant_app/features/home/data/models/restaurant_model.dart';

class OtherRestaurantsSection extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final Function(RestaurantModel) onRestaurantTap;
  final VoidCallback onSeeAllTap;

  const OtherRestaurantsSection({
    super.key,
    required this.restaurants,
    required this.onRestaurantTap,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.listOtherRestaurant,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.getTextPrimary(context),
                fontSize: 16.sp,
              ),
            ),
            GestureDetector(
              onTap: onSeeAllTap,
              child: Row(
                children: [
                  Text(
                    AppStrings.seeAll,
                    style: AppTextStyles.buttonSecondary.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12.sp,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 4.h),

        // Subtitle
        Text(
          AppStrings.checkCityNearbyRestaurant,
          style: AppTextStyles.bodyDescription.copyWith(
            color: AppColors.getTextSecondary(context),
            fontSize: 12.sp,
          ),
        ),

        SizedBox(height: 16.h),

        // Restaurants List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: restaurants.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return OtherRestaurantCard(
              restaurant: restaurants[index],
              onTap: () => onRestaurantTap(restaurants[index]),
            );
          },
        ),
      ],
    );
  }
}
