import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.headlineMedium.copyWith(
        fontSize: 16.sp,
        color: AppColors.getTextPrimary(context),
      ),
    );
  }
}
