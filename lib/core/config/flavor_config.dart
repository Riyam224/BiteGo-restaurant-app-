import 'package:flutter/material.dart';

enum Flavor {
  dev,
  prod,
}

class FlavorConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableAnalytics;
  final Color splashBackgroundColor;

  static FlavorConfig? _instance;

  FlavorConfig._internal({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.splashBackgroundColor,
  });

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception(
        'FlavorConfig is not initialized. Call FlavorConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  static void initialize({
    required Flavor flavor,
    required String appName,
    required String apiBaseUrl,
    required Color splashBackgroundColor,
    bool enableLogging = false,
    bool enableAnalytics = false,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      appName: appName,
      apiBaseUrl: apiBaseUrl,
      enableLogging: enableLogging,
      enableAnalytics: enableAnalytics,
      splashBackgroundColor: splashBackgroundColor,
    );
  }

  static bool get isDevelopment => instance.flavor == Flavor.dev;
  static bool get isProduction => instance.flavor == Flavor.prod;

  @override
  String toString() {
    return 'FlavorConfig(flavor: $flavor, appName: $appName, apiBaseUrl: $apiBaseUrl)';
  }
}
