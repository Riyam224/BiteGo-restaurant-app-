import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/home/data/models/new_arrival_model.dart';

class NewArrivalCard extends StatelessWidget {
  final NewArrivalModel item;
  final VoidCallback? onTap;

  const NewArrivalCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.getCardBorder(context),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.getShadow(context),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Stack(
                children: [
                  Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 180.h,
                        color: AppColors.getBackgroundSoft(context),
                        child: Icon(
                          Icons.restaurant,
                          size: 48.sp,
                          color: AppColors.textDisabled,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 180.h,
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
                  // Review count badge
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        '${item.reviewCount}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dish Name
                  Text(
                    item.name,
                    style: AppTextStyles.restaurantTitle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  // Restaurant location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          item.restaurantName,
                          style: AppTextStyles.restaurantSubtitle.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.getTextSecondary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
