import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/orders/data/models/order_model.dart';
import 'package:restaurant_app/features/orders/presentation/widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample orders data
  final List<OrderModel> _allOrders = [
    OrderModel(
      id: '1',
      orderNumber: 'ORD-2024-001',
      orderDate: DateTime.now().subtract(const Duration(hours: 2)),
      status: OrderStatus.outForDelivery,
      totalAmount: 52.97,
      deliveryAddress: 'Agrabad 435, Chittagong',
      estimatedDeliveryTime: '15 mins',
      trackingId: 'TRK-001',
      items: [
        OrderItem(
          id: '1',
          name: 'Chicken Biryani',
          imageUrl:
              'https://images.pexels.com/photos/20642812/pexels-photo-20642812.jpeg',
          price: 18.99,
          quantity: 2,
        ),
        OrderItem(
          id: '2',
          name: 'Margherita Pizza',
          imageUrl:
              'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg',
          price: 14.99,
          quantity: 1,
        ),
      ],
    ),
    OrderModel(
      id: '2',
      orderNumber: 'ORD-2024-002',
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      status: OrderStatus.delivered,
      totalAmount: 35.48,
      deliveryAddress: 'Agrabad 435, Chittagong',
      items: [
        OrderItem(
          id: '3',
          name: 'Beef Burger',
          imageUrl:
              'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg',
          price: 15.99,
          quantity: 1,
        ),
        OrderItem(
          id: '4',
          name: 'Caesar Salad',
          imageUrl:
              'https://images.pexels.com/photos/1059905/pexels-photo-1059905.jpeg',
          price: 12.99,
          quantity: 1,
        ),
      ],
    ),
    OrderModel(
      id: '3',
      orderNumber: 'ORD-2024-003',
      orderDate: DateTime.now().subtract(const Duration(days: 3)),
      status: OrderStatus.delivered,
      totalAmount: 48.97,
      deliveryAddress: 'Agrabad 435, Chittagong',
      items: [
        OrderItem(
          id: '5',
          name: 'Grilled Salmon',
          imageUrl:
              'https://images.pexels.com/photos/1516415/pexels-photo-1516415.jpeg',
          price: 24.99,
          quantity: 1,
        ),
        OrderItem(
          id: '6',
          name: 'Sushi Platter',
          imageUrl:
              'https://images.pexels.com/photos/357756/pexels-photo-357756.jpeg',
          price: 32.99,
          quantity: 1,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrderModel> get _activeOrders => _allOrders
      .where((order) =>
          order.status != OrderStatus.delivered &&
          order.status != OrderStatus.cancelled)
      .toList();

  List<OrderModel> get _pastOrders => _allOrders
      .where((order) =>
          order.status == OrderStatus.delivered ||
          order.status == OrderStatus.cancelled)
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Orders',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.getTextSecondary(context),
          indicatorColor: AppColors.primary,
          labelStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
          unselectedLabelStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 16.sp,
          ),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Past Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(_activeOrders, isActive: true),
          _buildOrdersList(_pastOrders, isActive: false),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders, {required bool isActive}) {
    if (orders.isEmpty) {
      return _buildEmptyState(isActive);
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(
          order: orders[index],
          onTap: () {
            // Navigate to order details
            debugPrint('View order: ${orders[index].orderNumber}');
          },
          onTrackOrder: orders[index].status == OrderStatus.outForDelivery
              ? () {
                  // Navigate to map tracking
                  debugPrint('Track order: ${orders[index].orderNumber}');
                }
              : null,
        );
      },
    );
  }

  Widget _buildEmptyState(bool isActive) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? Icons.shopping_bag_outlined : Icons.history,
            size: 100.w,
            color: AppColors.getTextSecondary(context),
          ),
          SizedBox(height: 20.h),
          Text(
            isActive ? 'No active orders' : 'No past orders',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            isActive
                ? 'Start ordering your favorite meals'
                : 'Your order history will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.getTextSecondary(context),
                ),
          ),
        ],
      ),
    );
  }
}
