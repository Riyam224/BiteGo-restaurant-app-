import 'package:flutter/material.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.textBlack,
    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.textBlack,
      surface: AppColors.textPrimary,
      error: AppColors.error,
      onPrimary: AppColors.textWhite,
      onSecondary: AppColors.textBlack,
      onBackground: AppColors.textWhite,
      onSurface: AppColors.textWhite,
      onError: AppColors.textWhite,
    ),

    textTheme: TextTheme(
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: AppColors.textWhite,
      ),
      headlineMedium: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textWhite,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.backgroundSoft,
      ),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.backgroundSoft,
      ),
      bodySmall: AppTextStyles.bodyDescription.copyWith(
        color: AppColors.backgroundSoft,
      ),
      labelLarge: AppTextStyles.labelMedium.copyWith(
        color: AppColors.textWhite,
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.textBlack,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textWhite,
      ),
      iconTheme: const IconThemeData(color: AppColors.textWhite),
    ),

    iconTheme: const IconThemeData(color: AppColors.backgroundSoft),

    cardTheme: CardThemeData(
      color: AppColors.textPrimary,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.textBlack,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.backgroundSoft,
    ),
  );
}
