import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/orders/data/models/order_model.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample orders data (same as orders screen)
    final allOrders = [
      OrderModel(
        id: '1',
        orderNumber: 'ORD-2024-001',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
        status: OrderStatus.outForDelivery,
        totalAmount: 52.97,
        deliveryAddress: 'Agrabad 435, Chittagong',
        estimatedDeliveryTime: '15 mins',
        trackingId: 'TRK-001',
        items: [],
      ),
      OrderModel(
        id: '2',
        orderNumber: 'ORD-2024-002',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.delivered,
        totalAmount: 35.48,
        deliveryAddress: 'Zakir Hossain Rd, Tech Tower, Chittagong',
        items: [],
      ),
      OrderModel(
        id: '3',
        orderNumber: 'ORD-2024-003',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
        status: OrderStatus.delivered,
        totalAmount: 48.97,
        deliveryAddress: 'Agrabad 435, Chittagong',
        items: [],
      ),
      OrderModel(
        id: '4',
        orderNumber: 'ORD-2024-004',
        orderDate: DateTime.now().subtract(const Duration(days: 5)),
        status: OrderStatus.delivered,
        totalAmount: 28.50,
        deliveryAddress: '6 Surson Road, Chittagong',
        items: [],
      ),
    ];

    // Extract unique addresses from orders
    final addressMap = <String, Map<String, dynamic>>{};
    for (var order in allOrders) {
      final address = order.deliveryAddress;
      if (!addressMap.containsKey(address)) {
        // Count how many times this address was used
        final orderCount =
            allOrders.where((o) => o.deliveryAddress == address).length;

        // Determine icon based on address content
        IconData icon = Icons.location_on;
        String type = 'Other';

        if (address.toLowerCase().contains('agrabad')) {
          icon = Icons.home;
          type = 'Home';
        } else if (address.toLowerCase().contains('tech') ||
            address.toLowerCase().contains('zakir')) {
          icon = Icons.business;
          type = 'Work';
        }

        addressMap[address] = {
          'address': address,
          'icon': icon,
          'type': type,
          'orderCount': orderCount,
          'lastUsed': allOrders
              .where((o) => o.deliveryAddress == address)
              .map((o) => o.orderDate)
              .reduce((a, b) => a.isAfter(b) ? a : b),
        };
      }
    }

    final addresses = addressMap.values.toList()
      ..sort((a, b) => (b['lastUsed'] as DateTime)
          .compareTo(a['lastUsed'] as DateTime));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Addresses',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: addresses.isEmpty
          ? _buildEmptyState(context, theme)
          : ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return _buildAddressCard(context, addresses[index], theme);
              },
            ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    Map<String, dynamic> address,
    ThemeData theme,
  ) {
    final orderCount = address['orderCount'] as int;
    final lastUsed = address['lastUsed'] as DateTime;
    final now = DateTime.now();
    final difference = now.difference(lastUsed);

    String timeAgo;
    if (difference.inHours < 24) {
      timeAgo = 'Used today';
    } else if (difference.inDays == 1) {
      timeAgo = 'Used yesterday';
    } else if (difference.inDays < 7) {
      timeAgo = 'Used ${difference.inDays} days ago';
    } else {
      timeAgo = 'Used ${(difference.inDays / 7).floor()} weeks ago';
    }

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
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    address['icon'] as IconData,
                    color: AppColors.primary,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address['type'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '$orderCount order${orderCount > 1 ? 's' : ''}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.getTextSecondary(context),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              address['address'] as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              timeAgo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.getTextSecondary(context),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 100.w,
            color: AppColors.getTextSecondary(context),
          ),
          SizedBox(height: 20.h),
          Text(
            'No Delivery Addresses',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your delivery addresses from orders\nwill appear here',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
