import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

/// Reusable quantity selector widget following SOLID principles
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            onTap: quantity > min ? () => onChanged(quantity - 1) : null,
          ),
          Container(
            width: 40.w,
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            onTap: quantity < max ? () => onChanged(quantity + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 36.w,
        height: 36.h,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18.w,
          color: onTap != null ? AppColors.primary : Colors.grey,
        ),
      ),
    );
  }
}
