import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/orders/data/models/order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  final VoidCallback? onTrackOrder;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onTrackOrder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.orderNumber,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            DateFormat('MMM dd, yyyy • hh:mm a')
                                .format(order.orderDate),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.getTextSecondary(context),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(context),
                  ],
                ),

                Divider(height: 24.h, color: Colors.grey.withValues(alpha: 0.2)),

                // Order items preview
                ...order.items.take(2).map((item) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              item.imageUrl,
                              width: 50.w,
                              height: 50.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 50.w,
                                height: 50.w,
                                color: Colors.grey[300],
                                child: Icon(Icons.fastfood,
                                    size: 25.w, color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Qty: ${item.quantity}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.getTextSecondary(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )),

                if (order.items.length > 2)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                    child: Text(
                      '+${order.items.length - 2} more items',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                Divider(height: 24.h, color: Colors.grey.withValues(alpha: 0.2)),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '\$${order.totalAmount.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    if (onTrackOrder != null)
                      ElevatedButton.icon(
                        onPressed: onTrackOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        icon: Icon(Icons.location_on, size: 18.w),
                        label: Text(
                          'Track',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                  ],
                ),

                if (order.estimatedDeliveryTime != null)
                  Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16.w,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Arrives in ${order.estimatedDeliveryTime}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (order.status) {
      case OrderStatus.pending:
        backgroundColor = Colors.orange.withValues(alpha: 0.2);
        textColor = Colors.orange;
        break;
      case OrderStatus.confirmed:
        backgroundColor = Colors.blue.withValues(alpha: 0.2);
        textColor = Colors.blue;
        break;
      case OrderStatus.preparing:
        backgroundColor = Colors.purple.withValues(alpha: 0.2);
        textColor = Colors.purple;
        break;
      case OrderStatus.outForDelivery:
        backgroundColor = AppColors.primary.withValues(alpha: 0.2);
        textColor = AppColors.primary;
        break;
      case OrderStatus.delivered:
        backgroundColor = Colors.green.withValues(alpha: 0.2);
        textColor = Colors.green;
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red.withValues(alpha: 0.2);
        textColor = Colors.red;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        order.status.displayName,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
      ),
    );
  }
}
