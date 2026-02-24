import 'package:flutter/material.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class CustomSubtitle extends StatelessWidget {
  const CustomSubtitle({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.seeAllButton.copyWith(
        color: AppColors.getTextSecondary(context),
      ),
    );
  }
}
