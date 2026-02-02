import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class AppTextStyles {
  static const String _font = AppStrings.appFontNameInter;

  // =========================
  // DISPLAY / HEADINGS
  // =========================

  /// Example: "Nearby restaurants"
  static TextStyle get displayTitle => TextStyle(
    fontFamily: _font,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Section titles
  static TextStyle get headlineLarge => TextStyle(
    fontFamily: _font,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontFamily: _font,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // =========================
  // BODY TEXT
  // =========================

  /// Onboarding / description text
  static TextStyle get bodyDescription => TextStyle(
    fontFamily: _font,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: _font,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: _font,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // =========================
  // BUTTONS
  // =========================

  /// Green filled button: "Create Account"
  static TextStyle get buttonPrimary => TextStyle(
    fontFamily: _font,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  /// Outline button text
  static TextStyle get buttonSecondary => TextStyle(
    fontFamily: _font,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  /// Text button: "Skip"
  static TextStyle get buttonText => TextStyle(
    fontFamily: _font,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // =========================
  // AUTH / ONBOARDING
  // =========================

  static TextStyle get onboardingTitle => TextStyle(
    fontFamily: _font,
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get onboardingBody => TextStyle(
    fontFamily: _font,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Welcome Screen Styles
  static TextStyle get welcomeTitle => TextStyle(
    fontFamily: _font,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle get welcomeDescription => TextStyle(
    fontFamily: _font,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get AuthLable => TextStyle(
    fontSize: 14,
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    height: 2.57,
  );

  static TextStyle get welcomeTerms => TextStyle(
    fontFamily: _font,
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
  );

  // Forget Password Styles
  static TextStyle get forgetPasswordTitle => TextStyle(
    fontFamily: _font,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    height: 1.80,
  );

  static TextStyle get forgetPasswordSubtitle => TextStyle(
    fontFamily: _font,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    height: 1.31,
  );

  static TextStyle get authLink => TextStyle(
    fontFamily: _font,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  // =========================
  // CARDS / LIST ITEMS
  // =========================

  /// Restaurant name
  static TextStyle get restaurantTitle => TextStyle(
    fontFamily: _font,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Restaurant subtitle / address
  static TextStyle get restaurantSubtitle => TextStyle(
    fontFamily: _font,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Menu item name
  static TextStyle get menuTitle => TextStyle(
    fontFamily: _font,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // =========================
  // LABELS / SMALL TEXT
  // =========================

  static TextStyle get labelSmall => TextStyle(
    fontFamily: _font,
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static TextStyle get labelMedium => TextStyle(
    fontFamily: _font,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // =========================
  // STATUS
  // =========================

  static TextStyle get error => TextStyle(
    fontFamily: _font,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  static TextStyle get success => TextStyle(
    fontFamily: _font,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
  );
}
