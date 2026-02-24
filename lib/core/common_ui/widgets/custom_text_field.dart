import 'package:flutter/material.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final Widget? suffix;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final int? maxLines;

  const CustomTextField({
    super.key,
    this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.suffix,
    this.trailing,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty)
          Text(
            label!,
            style: TextStyle(
              color: AppColors.getTextSecondary(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (label != null && label!.isNotEmpty) const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.getInputBackground(context),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.getInputBorder(context),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.getShadow(context),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  initialValue: controller == null ? initialValue : null,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  onChanged: onChanged,
                  validator: validator,
                  enabled: enabled,
                  maxLines: maxLines,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.getTextPrimary(context),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: AppColors.getTextSecondary(context).withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
              if (suffix != null) suffix!,
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (trailing != null) trailing!,
      ],
    );
  }
}
