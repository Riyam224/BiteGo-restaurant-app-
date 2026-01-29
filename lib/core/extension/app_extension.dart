import 'package:flutter/material.dart';
import 'package:restaurant_app/l10n/app_localizations.dart';

/// =========================
/// THEME EXTENSIONS
/// =========================

extension AppThemeExtension on BuildContext {
  ThemeData get appTheme => Theme.of(this);
}

extension BrightnessExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  bool get isLight => Theme.of(this).brightness == Brightness.light;
}

/// =========================
/// LOCALIZATION EXTENSION
/// =========================

extension LocalizationExtension on BuildContext {
  AppLocalizations get tr {
    final localization = AppLocalizations.of(this);
    if (localization == null) {
      throw FlutterError(
        'AppLocalizations not found in BuildContext.\n'
        'Make sure MaterialApp is configured with '
        'localizationsDelegates and supportedLocales.',
      );
    }
    return localization;
  }
}
