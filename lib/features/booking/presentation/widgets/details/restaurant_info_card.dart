import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class RestaurantInfoCard extends StatelessWidget {
  final String openStatus;
  final String openingHours;
  final bool isOpenNow;

  const RestaurantInfoCard({
    super.key,
    required this.openStatus,
    required this.openingHours,
    required this.isOpenNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
          // Status Indicator
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: isOpenNow ? AppColors.primary : AppColors.error,
              shape: BoxShape.circle,
            ),
          ),

          SizedBox(width: 12.w),

          // Open Status and Hours
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  openStatus,
                  style: AppTextStyles.restaurantTitle.copyWith(
                    color: isOpenNow ? AppColors.primary : AppColors.error,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  openingHours,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.getTextSecondary(context),
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
