import 'package:flutter/material.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ar.dart';

abstract class AppLocalizations {
  const AppLocalizations();

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // =========================
  // COMMON
  // =========================
  String get appName;
  String get skip;
  String get next;
  String get getStarted;

  // =========================
  // ONBOARDING
  // =========================
  String get onboardingTitle1;
  String get onboardingSubtitle1;

  String get onboardingTitle2;
  String get onboardingSubtitle2;

  String get onboardingTitle3;
  String get onboardingSubtitle3;

  // =========================
  // AUTH
  // =========================
  String get login;
  String get register;
  String get email;
  String get password;

  // Welcome Screen
  String get welcomeTitle;
  String get welcomeDescription;
  String get createAccount;
  String get termsPrefix;
  String get termsAndConditions;
  String get termsAndSeparator;
  String get privacyPolicy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'fr':
        return const AppLocalizationsFr();
      case 'ar':
        return const AppLocalizationsAr();
      case 'en':
      default:
        return const AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(_) => false;
}
