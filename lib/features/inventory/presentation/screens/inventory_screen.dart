import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final transactions = [
      {
        'id': '1',
        'itemName': 'Chicken Biryani',
        'type': 'Sale',
        'quantity': -2,
        'date': '2024-02-20 14:30',
        'orderNumber': 'ORD-2024-001',
        'stockAfter': 23,
      },
      {
        'id': '2',
        'itemName': 'Margherita Pizza',
        'type': 'Sale',
        'quantity': -1,
        'date': '2024-02-20 14:30',
        'orderNumber': 'ORD-2024-001',
        'stockAfter': 17,
      },
      {
        'id': '3',
        'itemName': 'Fresh Salmon (kg)',
        'type': 'Restock',
        'quantity': 10,
        'date': '2024-02-20 09:00',
        'orderNumber': 'SUPP-024',
        'stockAfter': 25,
      },
      {
        'id': '4',
        'itemName': 'Caesar Salad',
        'type': 'Sale',
        'quantity': -1,
        'date': '2024-02-19 18:45',
        'orderNumber': 'ORD-2024-002',
        'stockAfter': 14,
      },
      {
        'id': '5',
        'itemName': 'Beef Burger',
        'type': 'Sale',
        'quantity': -1,
        'date': '2024-02-19 18:45',
        'orderNumber': 'ORD-2024-002',
        'stockAfter': 34,
      },
      {
        'id': '6',
        'itemName': 'Chocolate Lava Cake',
        'type': 'Restock',
        'quantity': 20,
        'date': '2024-02-19 08:00',
        'orderNumber': 'SUPP-023',
        'stockAfter': 42,
      },
      {
        'id': '7',
        'itemName': 'Sushi Platter',
        'type': 'Adjustment',
        'quantity': -3,
        'date': '2024-02-18 20:00',
        'orderNumber': 'ADJ-018',
        'stockAfter': 12,
      },
      {
        'id': '8',
        'itemName': 'Grilled Salmon',
        'type': 'Sale',
        'quantity': -1,
        'date': '2024-02-18 19:30',
        'orderNumber': 'ORD-2024-003',
        'stockAfter': 11,
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Inventory Transactions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('Filter transactions');
            },
            icon: Icon(
              Icons.filter_list,
              color: AppColors.getIcon(context),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return _buildTransactionCard(context, transactions[index], theme);
        },
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    Map<String, dynamic> transaction,
    ThemeData theme,
  ) {
    final type = transaction['type'] as String;
    final quantity = transaction['quantity'] as int;
    final isSale = type == 'Sale';
    final isRestock = type == 'Restock';
    final isAdjustment = type == 'Adjustment';

    Color typeColor;
    IconData typeIcon;

    if (isSale) {
      typeColor = Colors.red;
      typeIcon = Icons.trending_down;
    } else if (isRestock) {
      typeColor = Colors.green;
      typeIcon = Icons.trending_up;
    } else {
      typeColor = Colors.orange;
      typeIcon = Icons.edit;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  typeIcon,
                  color: typeColor,
                  size: 24.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['itemName'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      transaction['date'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.getTextSecondary(context),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  type,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: typeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity Change',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.getTextSecondary(context),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        quantity > 0 ? Icons.add : Icons.remove,
                        color: typeColor,
                        size: 18.w,
                      ),
                      Text(
                        '${quantity.abs()} units',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: typeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Stock After',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.getTextSecondary(context),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${transaction['stockAfter']} units',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 16.w,
                  color: AppColors.getTextSecondary(context),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Ref: ${transaction['orderNumber']}',
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
    );
  }
}
