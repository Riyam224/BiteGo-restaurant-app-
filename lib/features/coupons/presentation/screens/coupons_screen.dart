import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final coupons = [
      {
        'code': 'FIRST20',
        'title': '20% Off First Order',
        'description': 'Get 20% discount on your first order',
        'discount': '20%',
        'minOrder': 15.0,
        'expiry': '2024-03-31',
        'isActive': true,
      },
      {
        'code': 'SUMMER50',
        'title': '\$50 Off on Orders Above \$200',
        'description': 'Flat \$50 off on orders worth \$200 or more',
        'discount': '\$50',
        'minOrder': 200.0,
        'expiry': '2024-04-15',
        'isActive': true,
      },
      {
        'code': 'FREESHIP',
        'title': 'Free Delivery',
        'description': 'Get free delivery on all orders',
        'discount': 'Free',
        'minOrder': 10.0,
        'expiry': '2024-05-01',
        'isActive': true,
      },
      {
        'code': 'WEEKEND15',
        'title': '15% Weekend Special',
        'description': 'Enjoy 15% off on weekend orders',
        'discount': '15%',
        'minOrder': 25.0,
        'expiry': '2024-02-25',
        'isActive': false,
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Coupons & Offers',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          return _buildCouponCard(context, coupon, theme);
        },
      ),
    );
  }

  Widget _buildCouponCard(
    BuildContext context,
    Map<String, dynamic> coupon,
    ThemeData theme,
  ) {
    final isActive = coupon['isActive'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            // Discount Badge
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.grey, Colors.grey.withValues(alpha: 0.7)],
                      ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    coupon['discount'] as String,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    'OFF',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),

            // Coupon Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon['title'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: isActive ? null : Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    coupon['description'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.getTextSecondary(context),
                      fontSize: 12.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primary
                            : Colors.grey,
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      coupon['code'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isActive ? AppColors.primary : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    isActive
                        ? 'Expires: ${coupon['expiry']}'
                        : 'Expired',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isActive
                          ? AppColors.getTextSecondary(context)
                          : Colors.red,
                      fontSize: 11.sp,
                    ),
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
