# Flutter Flavors Guide

This project is configured with two flavors: **dev** and **prod**.

## Overview

Flavors allow you to create different versions of your app with different configurations, such as different API endpoints, app names, and feature flags.

### Available Flavors

- **dev**: Development environment with debug features enabled
  - App Name: "BiteGo Dev"
  - Bundle ID (iOS): `com.example.restaurant_app.dev`
  - Application ID (Android): `com.example.restaurant_app.dev`
  - API Base URL: `https://dev-api.bitego.com`
  - Logging: Enabled
  - Analytics: Disabled

- **prod**: Production environment
  - App Name: "BiteGo"
  - Bundle ID (iOS): `com.example.restaurant_app`
  - Application ID (Android): `com.example.restaurant_app`
  - API Base URL: `https://api.bitego.com`
  - Logging: Disabled
  - Analytics: Enabled

## Running the App

### Using VSCode

1. Open the Run and Debug panel (Ctrl+Shift+D / Cmd+Shift+D)
2. Select one of the configurations:
   - **Dev Debug**: Run dev flavor in debug mode
   - **Dev Release**: Run dev flavor in release mode
   - **Prod Debug**: Run prod flavor in debug mode
   - **Prod Release**: Run prod flavor in release mode
3. Press F5 or click the green play button

### Using Command Line

#### Android

```bash
# Dev flavor
flutter run --flavor dev -t lib/main_dev.dart

# Prod flavor
flutter run --flavor prod -t lib/main_prod.dart
```

#### iOS

```bash
# Dev flavor
flutter run --flavor dev -t lib/main_dev.dart

# Prod flavor
flutter run --flavor prod -t lib/main_prod.dart
```

## Building the App

### Android

```bash
# Dev APK
flutter build apk --flavor dev -t lib/main_dev.dart

# Prod APK
flutter build apk --flavor prod -t lib/main_prod.dart

# Dev App Bundle
flutter build appbundle --flavor dev -t lib/main_dev.dart

# Prod App Bundle
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

### iOS

```bash
# Dev IPA
flutter build ipa --flavor dev -t lib/main_dev.dart

# Prod IPA
flutter build ipa --flavor prod -t lib/main_prod.dart
```

## Configuration Files

### Dart Files

- [lib/main_dev.dart](lib/main_dev.dart): Entry point for dev flavor
- [lib/main_prod.dart](lib/main_prod.dart): Entry point for prod flavor
- [lib/core/config/flavor_config.dart](lib/core/config/flavor_config.dart): Flavor configuration class

### Android

- [android/app/build.gradle.kts](android/app/build.gradle.kts): Flavor definitions

### iOS

- [ios/Flutter/Configurations/Debug-dev.xcconfig](ios/Flutter/Configurations/Debug-dev.xcconfig)
- [ios/Flutter/Configurations/Release-dev.xcconfig](ios/Flutter/Configurations/Release-dev.xcconfig)
- [ios/Flutter/Configurations/Debug-prod.xcconfig](ios/Flutter/Configurations/Debug-prod.xcconfig)
- [ios/Flutter/Configurations/Release-prod.xcconfig](ios/Flutter/Configurations/Release-prod.xcconfig)

## Using Flavor Configuration in Code

```dart
import 'package:restaurant_app/core/config/flavor_config.dart';

// Access flavor configuration
final config = FlavorConfig.instance;

print('Current flavor: ${config.flavor}');
print('API Base URL: ${config.apiBaseUrl}');
print('Logging enabled: ${config.enableLogging}');

// Check current environment
if (FlavorConfig.isDevelopment) {
  print('Running in development mode');
}

if (FlavorConfig.isProduction) {
  print('Running in production mode');
}
```

## Adding New Flavor-Specific Values

To add new flavor-specific configuration values:

1. Add the property to [lib/core/config/flavor_config.dart](lib/core/config/flavor_config.dart)
2. Set the value in [lib/main_dev.dart](lib/main_dev.dart) and [lib/main_prod.dart](lib/main_prod.dart)
3. Access it using `FlavorConfig.instance.yourProperty`

## iOS Xcode Configuration

To configure flavors in Xcode (if needed):

1. Open `Runner.xcworkspace` in Xcode
2. Select the Runner project in the navigator
3. Select the Runner target
4. Go to Build Settings
5. Under "User-Defined", you should see the flavor configurations

## Notes

- Both dev and prod flavors can be installed on the same device simultaneously (Android only)
- iOS requires separate bundle identifiers for each flavor
- Make sure to select the correct flavor when building for release
- Update API URLs in [lib/main_dev.dart](lib/main_dev.dart) and [lib/main_prod.dart](lib/main_prod.dart) as needed
