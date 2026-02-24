import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/home/data/models/restaurant_model.dart';

class OtherRestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onTap;

  const OtherRestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.getCardBorder(context),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Restaurant Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                restaurant.imageUrl,
                width: 60.w,
                height: 60.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60.w,
                    height: 60.h,
                    color: AppColors.getBackgroundSoft(context),
                    child: Icon(
                      Icons.restaurant,
                      color: AppColors.textDisabled,
                      size: 24.sp,
                    ),
                  );
                },
              ),
            ),

            SizedBox(width: 12.w),

            // Restaurant Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: AppTextStyles.restaurantTitle.copyWith(
                      color: AppColors.getTextPrimary(context),
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12.sp,
                        color: AppColors.getTextSecondary(context),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          restaurant.address,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.getTextSecondary(context),
                            fontSize: 11.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // Check Button
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                AppStrings.check,
                style: AppTextStyles.buttonPrimary.copyWith(
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
