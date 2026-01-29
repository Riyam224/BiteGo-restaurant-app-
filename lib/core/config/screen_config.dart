import 'dart:ui';

/// ScreenConfig - Centralized screen configuration
/// Contains all screen-related constants for ScreenUtil and responsive design
class ScreenConfig {
  const ScreenConfig._();

  // ========= DESIGN SIZE (from Figma/Design Tool) =========

  /// Design width from Figma (iPhone X/11 Pro width)
  static const double designWidth = 375.0;

  /// Design height from Figma (iPhone X/11 Pro height)
  static const double designHeight = 812.0;

  /// Design size as Size object for ScreenUtilInit
  static const Size designSize = Size(designWidth, designHeight);

  // ========= SCREEN UTIL OPTIONS =========

  /// Minimum text adapt - ensures text scales properly
  static const bool minTextAdapt = true;

  /// Split screen mode support
  static const bool splitScreenMode = true;

  // ========= DEVICE BREAKPOINTS =========

  /// Small phone screen width (e.g., iPhone SE)
  static const double smallPhoneWidth = 320.0;

  /// Medium phone screen width (e.g., iPhone 11 Pro)
  static const double mediumPhoneWidth = 375.0;

  /// Large phone screen width (e.g., iPhone 11 Pro Max)
  static const double largePhoneWidth = 414.0;

  /// Tablet screen width breakpoint
  static const double tabletWidth = 600.0;

  /// Desktop screen width breakpoint
  static const double desktopWidth = 1024.0;

  // ========= COMMON ASPECT RATIOS =========

  /// Standard iPhone aspect ratio (iPhone X, 11, 12, 13)
  static const double iphoneAspectRatio = 19.5 / 9;

  /// Standard Android aspect ratio
  static const double androidAspectRatio = 16 / 9;

  /// Square aspect ratio
  static const double squareAspectRatio = 1.0;

  // ========= SAFE AREA INSETS (typical values) =========

  /// Typical status bar height
  static const double statusBarHeight = 44.0;

  /// Typical bottom safe area (with home indicator)
  static const double bottomSafeArea = 34.0;

  /// Typical bottom safe area (without home indicator)
  static const double bottomSafeAreaLegacy = 20.0;

  // ========= HELPER METHODS =========

  /// Check if screen width is for a small phone
  static bool isSmallPhone(double width) => width <= smallPhoneWidth;

  /// Check if screen width is for a medium phone
  static bool isMediumPhone(double width) =>
      width > smallPhoneWidth && width <= mediumPhoneWidth;

  /// Check if screen width is for a large phone
  static bool isLargePhone(double width) =>
      width > mediumPhoneWidth && width < tabletWidth;

  /// Check if screen width is for a tablet
  static bool isTablet(double width) =>
      width >= tabletWidth && width < desktopWidth;

  /// Check if screen width is for a desktop
  static bool isDesktop(double width) => width >= desktopWidth;
}
