import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class RestaurantHeaderImage extends StatelessWidget {
  final String imageUrl;
  final String restaurantName;

  const RestaurantHeaderImage({
    super.key,
    required this.imageUrl,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240.h,
      decoration: BoxDecoration(
        color: AppColors.getBackgroundSoft(context),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.getBackgroundSoft(context),
            child: Center(
              child: Icon(
                Icons.restaurant,
                size: 64.sp,
                color: AppColors.textDisabled,
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: AppColors.getBackgroundSoft(context),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
