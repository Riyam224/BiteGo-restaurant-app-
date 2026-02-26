import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/cart/data/models/cart_item_model.dart';
import 'package:restaurant_app/features/cart/presentation/widgets/cart_item_card.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Sample cart items
  List<CartItemModel> _cartItems = [
    CartItemModel(
      id: '1',
      name: 'Chicken Biryani',
      imageUrl:
          'https://images.pexels.com/photos/20642812/pexels-photo-20642812.jpeg',
      price: 18.99,
      quantity: 2,
      category: 'Main Course',
    ),
    CartItemModel(
      id: '2',
      name: 'Margherita Pizza',
      imageUrl:
          'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg',
      price: 14.99,
      quantity: 1,
      category: 'Italian',
    ),
    CartItemModel(
      id: '3',
      name: 'Caesar Salad',
      imageUrl:
          'https://images.pexels.com/photos/1059905/pexels-photo-1059905.jpeg',
      price: 12.99,
      quantity: 1,
      category: 'Salads',
    ),
  ];

  double get _subtotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  double get _deliveryFee => 3.99;
  double get _tax => _subtotal * 0.1;
  double get _total => _subtotal + _deliveryFee + _tax;

  void _updateQuantity(String id, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _cartItems.removeWhere((item) => item.id == id);
      } else {
        final index = _cartItems.indexWhere((item) => item.id == id);
        if (index != -1) {
          _cartItems[index] =
              _cartItems[index].copyWith(quantity: newQuantity);
        }
      }
    });
  }

  void _removeItem(String id) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == id);
    });
  }

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
          'My Cart',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _cartItems.clear();
                });
              },
              icon: Icon(
                Icons.delete_outline,
                color: AppColors.getIcon(context),
              ),
            ),
        ],
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyCart(theme)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(20.w),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return CartItemCard(
                        item: item,
                        onQuantityChanged: (newQuantity) =>
                            _updateQuantity(item.id, newQuantity),
                        onRemove: () => _removeItem(item.id),
                      );
                    },
                  ),
                ),
                _buildCheckoutSection(theme),
              ],
            ),
    );
  }

  Widget _buildEmptyCart(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100.w,
            color: AppColors.getTextSecondary(context),
          ),
          SizedBox(height: 20.h),
          Text(
            'Your cart is empty',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add items to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.getBackground(context),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPriceRow('Subtotal', _subtotal, theme),
          SizedBox(height: 12.h),
          _buildPriceRow('Delivery Fee', _deliveryFee, theme),
          SizedBox(height: 12.h),
          _buildPriceRow('Tax', _tax, theme),
          Divider(height: 24.h),
          _buildPriceRow('Total', _total, theme, isBold: true),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () {
                // Handle checkout
                debugPrint('Proceed to checkout');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                'Proceed to Checkout',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount,
    ThemeData theme, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isBold
                ? AppColors.getTextPrimary(context)
                : AppColors.getTextSecondary(context),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18.sp : 16.sp,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.getTextPrimary(context),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 18.sp : 16.sp,
          ),
        ),
      ],
    );
  }
}
