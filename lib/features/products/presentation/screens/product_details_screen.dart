import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/common_ui/widgets/primary_button.dart';
import 'package:restaurant_app/core/common_ui/widgets/quantity_selector.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/models/product_model.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

/// Product details screen with add to cart functionality
/// Clean structure ready for Cubit/Bloc integration
class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  void _addToCart() {
    // TODO: Integrate with Cubit/Bloc later
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart!'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate back after adding to cart
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        title: Text(
          widget.product.name,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Hero(
              tag: 'product_${widget.product.id}',
              child: Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  color: AppColors.getBackgroundSoft(context),
                ),
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 80.sp,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Category
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      widget.product.category,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Rating & Reviews
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20.sp),
                      SizedBox(width: 4.w),
                      Text(
                        widget.product.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '(${widget.product.reviewCount} reviews)',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Price
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.5,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),

                  // Tags
                  if (widget.product.tags.isNotEmpty) ...[
                    SizedBox(height: 20.h),
                    Text(
                      'Tags',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: widget.product.tags.map((tag) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.getCardBackground(context),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.getCardBorder(context),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  SizedBox(height: 24.h),

                  // Quantity Selector
                  Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  QuantitySelector(
                    quantity: _quantity,
                    onChanged: (newQuantity) {
                      setState(() {
                        _quantity = newQuantity;
                      });
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Special Instructions
                  Text(
                    'Special Instructions (Optional)',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _instructionsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'E.g., No onions, extra spicy...',
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

                  SizedBox(height: 100.h), // Space for bottom button
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Action Button
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
            text: AppStrings.tryIt,
            onPressed: _addToCart,
          ),
        ),
      ),
    );
  }
}
