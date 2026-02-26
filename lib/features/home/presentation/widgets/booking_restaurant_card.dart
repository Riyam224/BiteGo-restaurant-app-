import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/common_ui/widgets/primary_button.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class BookingRestaurantCard extends StatelessWidget {
  final String restaurantName;
  final String address;
  final String imageUrl;
  final VoidCallback onBookPressed;
  final VoidCallback? onTap;

  const BookingRestaurantCard({
    super.key,
    required this.restaurantName,
    required this.address,
    required this.imageUrl,
    required this.onBookPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
              imageUrl,
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80.w,
                  height: 80.h,
                  color: AppColors.getBackgroundSoft(context),
                  child: Icon(
                    Icons.restaurant,
                    color: AppColors.textDisabled,
                    size: 32.sp,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  restaurantName,
                  style: AppTextStyles.restaurantTitle.copyWith(
                    color: AppColors.getTextPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        address,
                        style: AppTextStyles.restaurantSubtitle.copyWith(
                          color: AppColors.getTextSecondary(context),
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

          SizedBox(width: 12.w),

          // Try it Button
          PrimaryButton(
            text: AppStrings.tryIt,
            onPressed: onBookPressed,
          ),
        ],
      ),
      ),
    );
  }
}