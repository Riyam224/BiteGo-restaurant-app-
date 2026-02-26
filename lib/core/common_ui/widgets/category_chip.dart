import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/models/category_model.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

/// Horizontal category chip widget for home screen
class CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.getCardBorder(context),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category icon/image
            if (category.imageUrl != null && category.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: Image.network(
                  category.imageUrl!,
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.restaurant_menu,
                    size: 24.sp,
                    color: isSelected
                        ? Colors.white
                        : AppColors.getTextSecondary(context),
                  ),
                ),
              )
            else
              Icon(
                Icons.restaurant_menu,
                size: 24.sp,
                color: isSelected
                    ? Colors.white
                    : AppColors.getTextSecondary(context),
              ),

            SizedBox(width: 8.w),

            // Category name
            Text(
              category.name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : AppColors.getTextPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
