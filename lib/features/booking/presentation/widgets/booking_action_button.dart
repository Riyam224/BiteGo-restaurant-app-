import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class BookingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BookingActionButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadow(context),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                AppStrings.book,
                style: AppTextStyles.buttonPrimary.copyWith(
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
