import 'package:flutter/material.dart';

class AppColors {
  // ===== Brand Colors =====
  static const Color primary = Color(0xFF32B768); // Main green
  static const Color primaryDark = Color(0xFF0E7F3D); // Dark green
  static const Color primarySoft = Color(0xFFB3FFD1); // Mint highlight
  static const Color primaryLight = Color(0xFFD1FAE5); // Light green background
  static const Color primaryGreen = Color(0xFF10B981); // Green text for secondary button

  static const Color secondary = Color(0xFFEDB82C); // Yellow accent
  static const Color secondarySoft = Color(0xFFFDF0B9);

  static const Color accentOrange = Color(0xFFE06738);
  static const Color accentOrangeSoft = Color(0xFFF0C7A9);

  // ===== Light Theme Backgrounds =====
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSoft = Color(0xFFE6E6E6);

  // ===== Dark Theme Backgrounds =====
  static const Color backgroundDark = Color(0xFF121212);
  static const Color backgroundDarkSoft = Color(0xFF1E1E1E);

  // ===== Light Theme Text Colors =====
  static const Color textPrimary = Color(0xFF1F2937); // Headings
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textTertiary = Color(0xFF242323); // Terms text
  static const Color textDisabled = Color(0xFF9CA3AF); // Disabled/muted text
  static const Color textBlack = Color(0xFF000000);
  static const Color textWhite = Color(0xFFFFFFFF);

  // ===== Dark Theme Text Colors =====
  static const Color textPrimaryDark = Color(0xFFE5E7EB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFFD1D5DB);

  // ===== UI Elements =====
  static const Color border = Color(0xFFE6E6E6);
  static const Color divider = Color(0xFFE6E6E6);
  static const Color icon = Color(0xFF4B5563);

  // ===== Dark Theme UI Elements =====
  static const Color borderDark = Color(0xFF374151);
  static const Color dividerDark = Color(0xFF374151);
  static const Color iconDark = Color(0xFF9CA3AF);

  // ===== Status Colors =====
  static const Color success = Color(0xFF32B768);
  static const Color warning = Color(0xFFEDB82C);
  static const Color error = Color(0xFFE06738);

  // ===== Buttons =====
  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryText = textWhite;

  static const Color buttonSecondary = secondary;
  static const Color buttonSecondaryText = textBlack;

  // ===== Light Theme Cards =====
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE6E6E6);

  // ===== Dark Theme Cards =====
  static const Color cardBackgroundDark = Color(0xFF1E1E1E);
  static const Color cardBorderDark = Color(0xFF374151);

  // ===== Light Theme Input Fields =====
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFE6E6E6);
  static const Color inputFocusedBorder = primary;

  // ===== Dark Theme Input Fields =====
  static const Color inputBackgroundDark = Color(0xFF1E1E1E);
  static const Color inputBorderDark = Color(0xFF374151);

  // ===== Shadows =====
  static const Color shadow = Color(0x14000000); // 8% black
  static const Color shadowDark = Color(0x40000000); // 25% black for dark mode

  // ===== Promo Carousel Gradients =====
  static const Color promoOrangeLight = Color(0xFFFFD4A3);
  static const Color promoOrangeMedium = Color(0xFFFFB366);

  static const Color promoGreenLight = Color(0xFF86EFAC);
  static const Color promoGreenMedium = Color(0xFF4ADE80);

  static const Color promoRedLight = Color(0xFFFCA5A5);
  static const Color promoRedMedium = Color(0xFFF87171);

  // ===== Theme-aware getters =====
  static Color getBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? backgroundDark
          : background;

  static Color getBackgroundSoft(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? backgroundDarkSoft
          : backgroundSoft;

  static Color getTextPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? textPrimaryDark
          : textPrimary;

  static Color getTextSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? textSecondaryDark
          : textSecondary;

  static Color getCardBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? cardBackgroundDark
          : cardBackground;

  static Color getCardBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? cardBorderDark
          : cardBorder;

  static Color getInputBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? inputBackgroundDark
          : inputBackground;

  static Color getInputBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? inputBorderDark
          : inputBorder;

  static Color getBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? borderDark : border;

  static Color getIcon(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? iconDark : icon;

  static Color getShadow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? shadowDark : shadow;
}
