import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/flavor_config.dart';
import 'package:restaurant_app/core/config/screen_config.dart';
import 'package:restaurant_app/core/routing/app_router.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/core/utils/app_theme.dart';
import 'package:restaurant_app/firebase_options.dart';
import 'package:restaurant_app/l10n/app_localizations.dart';

bool _isFlavorInitialized() {
  try {
    FlavorConfig.instance;
    return true;
  } catch (e) {
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize default flavor (dev) if not already initialized
  // This is overridden when running through main_dev.dart or main_prod.dart
  if (!_isFlavorInitialized()) {
    FlavorConfig.initialize(
      flavor: Flavor.dev,
      appName: 'BiteGo Dev',
      apiBaseUrl: 'https://dev-api.bitego.com',
      splashBackgroundColor: AppColors.primary,
      enableLogging: true,
      enableAnalytics: false,
    );
  }

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const BiteGo());
  });
}

class BiteGo extends StatelessWidget {
  const BiteGo({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: ScreenConfig.designSize,
      minTextAdapt: ScreenConfig.minTextAdapt,
      splitScreenMode: ScreenConfig.splitScreenMode,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: RouteGenerator.mainRoutingInOurApp,

          // ========= THEMING =========
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system, // Follow system theme
          // ========= LOCALIZATION =========
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: const [
            Locale('en', ''), // English
            Locale('fr', ''), // French
            Locale('ar', ''), // Arabic
          ],

          // Locale resolution strategy
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the device locale is supported
            if (locale != null) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
            }
            // Fallback to English if device locale not supported
            return supportedLocales.first;
          },

          // Optional: Set a specific locale (comment out to use device locale)
          // locale: const Locale('en', ''),

          // App title for task switcher
          title: 'BiteGo',
        );
      },
    );
  }
}
