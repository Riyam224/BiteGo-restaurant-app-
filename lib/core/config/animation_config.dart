import 'package:flutter/material.dart';

/// AnimationConfig - Centralized animation configurations
/// Contains all animation durations, curves, and animation values
class AnimationConfig {
  const AnimationConfig._();

  // ========= SPLASH SCREEN ANIMATIONS =========

  /// Splash screen fade and scale animation duration
  static const Duration splashAnimationDuration = Duration(seconds: 3);

  /// Splash screen animation curve
  static const Curve splashAnimationCurve = Curves.easeInOut;

  /// Splash screen scale animation begin value
  static const double splashScaleBegin = 0.85;

  /// Splash screen scale animation end value
  static const double splashScaleEnd = 1.0;

  // ========= ONBOARDING ANIMATIONS =========

  /// Page transition duration for onboarding
  static const Duration onboardingPageTransition = Duration(milliseconds: 300);

  /// Indicator animation duration
  static const Duration indicatorAnimation = Duration(milliseconds: 250);

  // ========= GENERAL ANIMATIONS =========

  /// Standard fade animation duration
  static const Duration standardFadeDuration = Duration(milliseconds: 300);

  /// Standard slide animation duration
  static const Duration standardSlideDuration = Duration(milliseconds: 250);

  /// Button press animation duration
  static const Duration buttonPressDuration = Duration(milliseconds: 150);

  /// Modal transition duration
  static const Duration modalTransition = Duration(milliseconds: 350);

  /// Card flip animation duration
  static const Duration cardFlipDuration = Duration(milliseconds: 600);

  /// List item animation duration
  static const Duration listItemAnimation = Duration(milliseconds: 200);

  /// Shimmer animation duration
  static const Duration shimmerDuration = Duration(milliseconds: 1500);

  // ========= CURVES =========

  /// Standard animation curve
  static const Curve standardCurve = Curves.easeInOut;

  /// Bounce animation curve
  static const Curve bounceCurve = Curves.elasticOut;

  /// Fast out slow in curve
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  /// Linear curve
  static const Curve linearCurve = Curves.linear;

  /// Ease in curve
  static const Curve easeInCurve = Curves.easeIn;

  /// Ease out curve
  static const Curve easeOutCurve = Curves.easeOut;

  // ========= SCALE VALUES =========

  /// Button scale on press (begin)
  static const double buttonScaleBegin = 1.0;

  /// Button scale on press (end)
  static const double buttonScaleEnd = 0.95;

  /// Card hover scale
  static const double cardHoverScale = 1.05;

  /// Icon pulse scale
  static const double iconPulseScale = 1.2;

  // ========= OPACITY VALUES =========

  /// Fully transparent
  static const double opacityTransparent = 0.0;

  /// Semi transparent
  static const double opacitySemiTransparent = 0.5;

  /// Nearly opaque
  static const double opacityNearlyOpaque = 0.8;

  /// Fully opaque
  static const double opacityOpaque = 1.0;

  // ========= ROTATION VALUES =========

  /// Quarter turn rotation (90 degrees)
  static const double rotationQuarter = 0.25;

  /// Half turn rotation (180 degrees)
  static const double rotationHalf = 0.5;

  /// Three quarter turn rotation (270 degrees)
  static const double rotationThreeQuarter = 0.75;

  /// Full turn rotation (360 degrees)
  static const double rotationFull = 1.0;
}
