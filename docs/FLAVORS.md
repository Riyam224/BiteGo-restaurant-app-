# App Flavors Guide

## What are Flavors?

Flavors allow you to create different versions of your app from the same codebase. Think of it like having a "testing version" and a "production version" of your app, each with different settings.

## Why Use Flavors?

- **Separate Environments**: Test new features without affecting the live app
- **Different API Endpoints**: Dev uses test servers, Prod uses real servers
- **Visual Distinction**: Different colors/names help you know which version you're running
- **Easy Switching**: Run any version with a simple command

---

## Available Flavors

### 1. Dev (Development)
**Purpose**: For testing and development

**Settings:**
- App Name: `BiteGo Dev`
- Package ID: `com.example.restaurant_app.dev`
- API URL: `https://dev-api.bitego.com`
- Splash Color: Yellow/Gold (#EDB82C)
- Logging: Enabled
- Analytics: Disabled

**When to use:**
- Testing new features
- Debugging issues
- Development work
- QA testing

### 2. Prod (Production)
**Purpose**: For real users

**Settings:**
- App Name: `BiteGo`
- Package ID: `com.example.restaurant_app`
- API URL: `https://api.bitego.com`
- Splash Color: Green (#32B768)
- Logging: Disabled
- Analytics: Enabled

**When to use:**
- Releasing to app stores
- Production builds
- End users

---

## How to Run Each Flavor

### Running Dev Flavor

```bash
flutter run --flavor dev -t lib/main_dev.dart
```

### Running Prod Flavor

```bash
flutter run --flavor prod -t lib/main_prod.dart
```

### Building Release APKs

**Dev Release:**
```bash
flutter build apk --flavor dev -t lib/main_dev.dart --release
```

**Prod Release:**
```bash
flutter build apk --flavor prod -t lib/main_prod.dart --release
```

### Building App Bundles (for Play Store)

**Dev Bundle:**
```bash
flutter build appbundle --flavor dev -t lib/main_dev.dart
```

**Prod Bundle:**
```bash
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

---

## How It Works

### 1. Entry Points
Each flavor has its own entry file:
- `lib/main_dev.dart` - Dev flavor entry point
- `lib/main_prod.dart` - Prod flavor entry point

### 2. Flavor Configuration
Each entry file initializes the `FlavorConfig` with different settings:

```dart
// main_dev.dart
FlavorConfig.initialize(
  flavor: Flavor.dev,
  appName: 'BiteGo Dev',
  apiBaseUrl: 'https://dev-api.bitego.com',
  splashBackgroundColor: AppColors.secondary,
  enableLogging: true,
  enableAnalytics: false,
);
```

```dart
// main_prod.dart
FlavorConfig.initialize(
  flavor: Flavor.prod,
  appName: 'BiteGo',
  apiBaseUrl: 'https://api.bitego.com',
  splashBackgroundColor: AppColors.primary,
  enableLogging: false,
  enableAnalytics: true,
);
```

### 3. Android Configuration
The Android build system is configured in `android/app/build.gradle.kts`:

```kotlin
productFlavors {
    create("dev") {
        dimension = "app"
        applicationIdSuffix = ".dev"
        versionNameSuffix = "-dev"
        resValue("string", "app_name", "BiteGo Dev")
    }

    create("prod") {
        dimension = "app"
        resValue("string", "app_name", "BiteGo")
    }
}
```

### 4. Using Flavor Config in Code

Access flavor-specific settings anywhere in your app:

```dart
// Get current flavor
final currentFlavor = FlavorConfig.instance.flavor;

// Get API URL
final apiUrl = FlavorConfig.instance.apiBaseUrl;

// Get splash color
final splashColor = FlavorConfig.instance.splashBackgroundColor;

// Check if logging is enabled
if (FlavorConfig.instance.enableLogging) {
  print('Debug log');
}
```

---

## Visual Differences

When you run the app, you can immediately tell which flavor you're using:

| Feature | Dev | Prod |
|---------|-----|------|
| App Name | BiteGo Dev | BiteGo |
| Splash Screen | Yellow/Gold | Green |
| App Icon Badge | Shows ".dev" | No badge |

---

## Installing Both Versions

Because Dev and Prod have different package IDs, you can install both versions on the same device:
- Dev: `com.example.restaurant_app.dev`
- Prod: `com.example.restaurant_app`

This is useful for comparing behaviors or testing both versions simultaneously.

---

## Adding a New Flavor

If you need to add a new flavor (e.g., "staging"):

### Step 1: Create Entry Point
Create `lib/main_staging.dart`:

```dart
import 'package:restaurant_app/core/config/flavor_config.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'main.dart' as app;

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.staging,
    appName: 'BiteGo Staging',
    apiBaseUrl: 'https://staging-api.bitego.com',
    splashBackgroundColor: AppColors.accentOrange,
    enableLogging: true,
    enableAnalytics: true,
  );

  app.main();
}
```

### Step 2: Update Flavor Enum
In `lib/core/config/flavor_config.dart`, add to the `Flavor` enum:

```dart
enum Flavor {
  dev,
  staging,  // Add this
  prod,
}
```

### Step 3: Update Android Configuration
In `android/app/build.gradle.kts`, add:

```kotlin
create("staging") {
    dimension = "app"
    applicationIdSuffix = ".staging"
    versionNameSuffix = "-staging"
    resValue("string", "app_name", "BiteGo Staging")
}
```

### Step 4: Run It
```bash
flutter run --flavor staging -t lib/main_staging.dart
```

---

## Troubleshooting

### Issue: "Flavor not found"
**Solution**: Make sure the flavor name in your command matches the name in `build.gradle.kts`

### Issue: "Cannot find main_*.dart"
**Solution**: Ensure you're using the correct `-t` parameter pointing to the right entry file

### Issue: Both versions look the same
**Solution**: Make sure you're running with the correct flavor parameter and the right entry point

### Issue: Wrong API being called
**Solution**: Check that `FlavorConfig.instance.apiBaseUrl` is being used in your API client, not a hardcoded URL

---

## Best Practices

1. **Always use flavor commands**: Don't run `flutter run` without specifying a flavor
2. **Use FlavorConfig**: Access settings through `FlavorConfig.instance` instead of hardcoding
3. **Test both flavors**: Before releasing, test that both dev and prod work correctly
4. **Visual distinction**: Keep the splash colors different so you know which version is running
5. **Logging**: Keep logging enabled in dev, disabled in prod for better performance

---

## Quick Reference

```bash
# Run dev
flutter run --flavor dev -t lib/main_dev.dart

# Run prod
flutter run --flavor prod -t lib/main_prod.dart

# Build dev APK
flutter build apk --flavor dev -t lib/main_dev.dart --release

# Build prod APK
flutter build apk --flavor prod -t lib/main_prod.dart --release

# Clean build (if something goes wrong)
flutter clean && flutter pub get
```

---

## Summary

Flavors help you maintain different versions of your app easily:
- **Dev** = Yellow splash, test API, logging on
- **Prod** = Green splash, real API, analytics on
- Both can be installed simultaneously
- Switch between them with simple commands

For more details, see the implementation files:
- Entry points: `lib/main_dev.dart`, `lib/main_prod.dart`
- Configuration: `lib/core/config/flavor_config.dart`
- Android setup: `android/app/build.gradle.kts`
