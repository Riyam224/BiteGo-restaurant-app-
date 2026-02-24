import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class VisitRestaurantButton extends StatelessWidget {
  final VoidCallback onPressed;

  const VisitRestaurantButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              color: AppColors.textWhite,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Visit the Restaurant',
              style: AppTextStyles.buttonPrimary.copyWith(
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
