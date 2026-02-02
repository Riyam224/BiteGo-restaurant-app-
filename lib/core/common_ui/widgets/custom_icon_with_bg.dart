import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_sizing.dart';

class CustomIconWithBg extends StatelessWidget {
  final Color? backgroundColor;
  final String iconImg;
  final Color? iconColor;
  final double? size;

  final void Function()? onTap;

  const CustomIconWithBg({
    super.key,
    this.backgroundColor,
    this.iconColor,
    this.size,
    required this.iconImg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size ?? AppSizing.iconContainerLarge,
        height: size ?? AppSizing.iconContainerLarge,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSizing.iconBorderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSizing.iconContainerPadding),
          child: Image.asset(
            iconImg,
            width: AppSizing.iconImageSize,
            height: AppSizing.iconImageSize,
          ),
        ),
      ),
    );
  }
}
