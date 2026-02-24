import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/booking/data/models/booking_model.dart';

class BookingHistoryCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  const BookingHistoryCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (booking.status.toLowerCase()) {
      case 'active':
        return AppColors.primary;
      case 'pending':
        return AppColors.warning;
      case 'completed':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

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
          boxShadow: [
            BoxShadow(
              color: AppColors.getShadow(context),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Restaurant Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                booking.imageUrl,
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

            // Booking Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.restaurantName,
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
                        Icons.calendar_today,
                        size: 14.sp,
                        color: AppColors.getTextSecondary(context),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        booking.date,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: AppColors.getTextSecondary(context),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          booking.time,
                          style: AppTextStyles.labelMedium.copyWith(
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

            SizedBox(width: 8.w),

            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                booking.status,
                style: AppTextStyles.labelSmall.copyWith(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
