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

  // ===== Backgrounds =====
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSoft = Color(0xFFE6E6E6);

  // ===== Text Colors =====
  static const Color textPrimary = Color(0xFF1F2937); // Headings
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textTertiary = Color(0xFF242323); // Terms text
  static const Color textDisabled = Color(0xFF9CA3AF); // Disabled/muted text
  static const Color textBlack = Color(0xFF000000);
  static const Color textWhite = Color(0xFFFFFFFF);

  // ===== UI Elements =====
  static const Color border = Color(0xFFE6E6E6);
  static const Color divider = Color(0xFFE6E6E6);
  static const Color icon = Color(0xFF4B5563);

  // ===== Status Colors =====
  static const Color success = Color(0xFF32B768);
  static const Color warning = Color(0xFFEDB82C);
  static const Color error = Color(0xFFE06738);

  // ===== Buttons =====
  static const Color buttonPrimary = primary;
  static const Color buttonPrimaryText = textWhite;

  static const Color buttonSecondary = secondary;
  static const Color buttonSecondaryText = textBlack;

  // ===== Cards =====
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE6E6E6);

  // ===== Input Fields =====
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFE6E6E6);
  static const Color inputFocusedBorder = primary;

  // ===== Shadows =====
  static const Color shadow = Color(0x14000000); // 8% black
}
