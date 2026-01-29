import 'package:flutter/material.dart';

import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_sizing.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? radius;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.radius,
    this.color,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? AppSizing.buttonHeightWelcome;
    final buttonRadius = radius ?? AppSizing.radius12;

    return SizedBox(
      width: AppSizing.buttonWidthWelcome,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: AppSizing.w64,
            vertical: AppSizing.h16,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: AppSizing.borderMedium,
            ),
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.buttonPrimary.copyWith(
            color: textColor ?? AppColors.textWhite,
            fontFamily: AppStrings.appFontNameInter,
          ),
        ),
      ),
    );
  }
}
