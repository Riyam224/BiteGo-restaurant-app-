import 'package:flutter/material.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class SeeAllWithIcon extends StatelessWidget {
  const SeeAllWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'See All',
          style: AppTextStyles.seeAllButton.copyWith(
            color: AppColors.getTextSecondary(context),
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: AppColors.getTextSecondary(context),
        ),
      ],
    );
  }
}
