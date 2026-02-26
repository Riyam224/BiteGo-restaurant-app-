import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/common_ui/widgets/primary_button.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

/// Checkout screen for order creation
/// Clean structure ready for Cubit/Bloc integration
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'cash';
  final TextEditingController _deliveryInstructionsController = TextEditingController();
  bool _isCreatingOrder = false;

  @override
  void dispose() {
    _deliveryInstructionsController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    setState(() => _isCreatingOrder = true);

    // TODO: Integrate with Cubit/Bloc for order creation
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isCreatingOrder = false);

    if (mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Order placed successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate back to home
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        title: Text(
          AppStrings.checkout,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        backgroundColor: AppColors.getBackground(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.getTextPrimary(context)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Section
            _buildSectionHeader('Delivery Address'),
            SizedBox(height: 12.h),
            _buildAddressCard(),

            SizedBox(height: 24.h),

            // Payment Method Section
            _buildSectionHeader('Payment Method'),
            SizedBox(height: 12.h),
            _buildPaymentMethodSelector(),

            SizedBox(height: 24.h),

            // Order Summary Section
            _buildSectionHeader('Order Summary'),
            SizedBox(height: 12.h),
            _buildOrderSummary(),

            SizedBox(height: 24.h),

            // Delivery Instructions
            _buildSectionHeader('Delivery Instructions (Optional)'),
            SizedBox(height: 12.h),
            TextField(
              controller: _deliveryInstructionsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'E.g., Ring doorbell, leave at door...',
                hintStyle: TextStyle(
                  color: AppColors.getTextSecondary(context),
                  fontSize: 14.sp,
                ),
                filled: true,
                fillColor: AppColors.getCardBackground(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.getCardBorder(context),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.getCardBorder(context),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),

            SizedBox(height: 100.h),
          ],
        ),
      ),

      // Place Order Button
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.getBackground(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: PrimaryButton(
            text: 'Place Order - \$0.00',
            onPressed: _isCreatingOrder ? null : _placeOrder,
            isLoading: _isCreatingOrder,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextPrimary(context),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.getCardBorder(context),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Default Address',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Please select a delivery address',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.getTextSecondary(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      children: [
        _buildPaymentOption('cash', 'Cash on Delivery', Icons.money),
        SizedBox(height: 12.h),
        _buildPaymentOption('card', 'Credit/Debit Card', Icons.credit_card),
        SizedBox(height: 12.h),
        _buildPaymentOption('wallet', 'Digital Wallet', Icons.account_balance_wallet),
      ],
    );
  }

  Widget _buildPaymentOption(String value, String label, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.getCardBorder(context),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.getBackgroundSoft(context),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.getTextSecondary(context),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.getTextPrimary(context),
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.getCardBorder(context),
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', '\$0.00'),
          SizedBox(height: 12.h),
          _buildSummaryRow('Delivery Fee', '\$3.99'),
          SizedBox(height: 12.h),
          _buildSummaryRow('Tax', '\$0.00'),
          SizedBox(height: 12.h),
          Divider(color: AppColors.getCardBorder(context)),
          SizedBox(height: 12.h),
          _buildSummaryRow('Total', '\$3.99', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal
                ? AppColors.getTextPrimary(context)
                : AppColors.getTextSecondary(context),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? AppColors.primary : AppColors.getTextPrimary(context),
          ),
        ),
      ],
    );
  }
}
