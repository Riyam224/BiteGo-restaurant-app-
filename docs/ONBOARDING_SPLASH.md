# Onboarding & Splash Screen

> First-launch experience and app initialization in BiteGo

## Table of Contents

- [Overview](#overview)
- [Splash Screen](#splash-screen)
- [Onboarding Flow](#onboarding-flow)
- [Navigation Logic](#navigation-logic)
- [Implementation Details](#implementation-details)
- [Customization Guide](#customization-guide)

## Overview

The app's first-launch experience consists of two main components:

1. **Splash Screen** - Animated brand introduction on every app launch
2. **Onboarding** - One-time tutorial screens for new users

### User Journey

```
App Launch
    ↓
┌─────────────────┐
│  Splash Screen  │  (3 seconds animation)
└────────┬────────┘
         │
         ▼
   First Time?
    /        \
  YES        NO
   ↓          ↓
Onboarding  Welcome
   ↓
Skip/Complete
   ↓
Welcome Screen
```

---

## Splash Screen

### Purpose
- Display app branding
- Initialize app dependencies
- Determine navigation destination

### Location
[lib/features/splash/presentation/screens/splash_screen.dart](../lib/features/splash/presentation/screens/splash_screen.dart)

### Implementation

```dart
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check if user has completed onboarding
    final hasCompletedOnboarding = await AppPrefs().isOnboardingCompleted();

    if (hasCompletedOnboarding) {
      // Go directly to welcome/login
      context.go(RouteNames.welcome);
    } else {
      // Show onboarding for first-time users
      context.go(RouteNames.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo with fade-in animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: AnimationConfig.splashAnimationDuration,
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: child,
                );
              },
              child: Image.asset(
                AppAssets.appLogo,
                width: 200.w,
                height: 200.h,
              ),
            ),
            SizedBox(height: 24.h),
            // App name
            Text(
              AppStrings.appName,
              style: AppTextStyles.h1.copyWith(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            // Tagline
            Text(
              AppStrings.appTagline,
              style: AppTextStyles.body.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Features

1. **Fade-in Animation**
   - Logo and text fade in over 1 second
   - Smooth, professional appearance

2. **Navigation Logic**
   ```dart
   if (onboarding completed) {
     Navigate to Welcome Screen
   } else {
     Navigate to Onboarding
   }
   ```

3. **Responsive Design**
   - Uses `flutter_screenutil` for adaptive sizing
   - Scales appropriately on all devices

### Configuration

**Location**: [lib/core/config/animation_config.dart](../lib/core/config/animation_config.dart)

```dart
class AnimationConfig {
  static const Duration splashAnimationDuration = Duration(seconds: 1);
  static const Duration splashScreenDuration = Duration(seconds: 3);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve splashCurve = Curves.easeIn;
}
```

---

## Onboarding Flow

### Purpose
- Introduce app features to first-time users
- Set user expectations
- Create positive first impression

### Location
[lib/features/onboarding/presentation/screens/onboarding_screen.dart](../lib/features/onboarding/presentation/screens/onboarding_screen.dart)

### File Structure

```
lib/features/onboarding/
├── data/
│   ├── constants/
│   │   └── onboarding_constants.dart    # Onboarding content
│   └── models/
│       └── onboarding_model.dart         # Data structure
└── presentation/
    ├── screens/
    │   └── onboarding_screen.dart        # Main screen
    └── widgets/
        ├── onboarding_page_item.dart     # Single page
        └── onboarding_page_indicator.dart # Dots indicator
```

### Onboarding Model

```dart
// lib/features/onboarding/data/models/onboarding_model.dart
class OnboardingModel {
  final String title;
  final String description;
  final String image;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });
}
```

### Onboarding Content

```dart
// lib/features/onboarding/data/constants/onboarding_constants.dart
class OnboardingConstants {
  static const List<OnboardingModel> pages = [
    OnboardingModel(
      title: 'Browse Restaurants',
      description: 'Discover the best restaurants near you with just a few taps',
      image: AppAssets.onboarding1,
    ),
    OnboardingModel(
      title: 'Order Your Favorites',
      description: 'Choose from a wide variety of delicious meals and cuisines',
      image: AppAssets.onboarding2,
    ),
    OnboardingModel(
      title: 'Fast Delivery',
      description: 'Get your food delivered to your doorstep quickly and safely',
      image: AppAssets.onboarding3,
    ),
  ];
}
```

### Implementation

```dart
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Future<void> _completeOnboarding() async {
    // Mark onboarding as completed
    await AppPrefs().setOnboardingCompleted(true);

    if (!mounted) return;

    // Navigate to welcome screen
    context.go(RouteNames.welcome);
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _nextPage() {
    if (_currentPage < OnboardingConstants.pages.length - 1) {
      _pageController.nextPage(
        duration: AnimationConfig.pageTransitionDuration,
        curve: AnimationConfig.defaultCurve,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skipOnboarding,
                child: Text('Skip'),
              ),
            ),

            // PageView with onboarding pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: OnboardingConstants.pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageItem(
                    page: OnboardingConstants.pages[index],
                  );
                },
              ),
            ),

            // Page indicator (dots)
            OnboardingPageIndicator(
              currentPage: _currentPage,
              pageCount: OnboardingConstants.pages.length,
            ),

            SizedBox(height: 32.h),

            // Next/Get Started button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: PrimaryButton(
                text: _currentPage == OnboardingConstants.pages.length - 1
                    ? 'Get Started'
                    : 'Next',
                onPressed: _nextPage,
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
```

### Features

#### 1. Page Indicators (Dots)

```dart
// lib/features/onboarding/presentation/widgets/onboarding_page_indicator.dart
class OnboardingPageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: AnimationConfig.pageTransitionDuration,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: index == currentPage ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: index == currentPage
                ? AppColors.primary
                : AppColors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}
```

**Visual**:
- Active page: Long pill shape (primary color)
- Inactive pages: Small circles (gray)
- Smooth animation between pages

#### 2. Skip Button

```dart
TextButton(
  onPressed: () async {
    await AppPrefs().setOnboardingCompleted(true);
    if (mounted) context.go(RouteNames.welcome);
  },
  child: Text('Skip'),
)
```

- Positioned top-right
- Skips all pages and goes to welcome screen
- Marks onboarding as completed

#### 3. Dynamic Button Text

```dart
text: _currentPage == OnboardingConstants.pages.length - 1
    ? 'Get Started'  // Last page
    : 'Next'         // Other pages
```

#### 4. Page Item Widget

```dart
// lib/features/onboarding/presentation/widgets/onboarding_page_item.dart
class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel page;

  const OnboardingPageItem({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Image.asset(
            page.image,
            width: 300.w,
            height: 300.h,
            fit: BoxFit.contain,
          ),

          SizedBox(height: 48.h),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.h2,
          ),

          SizedBox(height: 16.h),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Navigation Logic

### Initial Navigation Flow

**Location**: [lib/main.dart](../lib/main.dart)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          // Always starts with splash screen
        );
      },
    );
  }
}
```

### Router Configuration

**Location**: [lib/core/routing/app_router.dart](../lib/core/routing/app_router.dart)

```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
```

### Storage Management

**Location**: [lib/core/storage/shared_prefs.dart](../lib/core/storage/shared_prefs.dart)

```dart
class AppPrefs {
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  // Check if onboarding was completed
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  // Mark onboarding as completed
  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
  }
}
```

---

## Implementation Details

### Page Transition Animation

```dart
_pageController.nextPage(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
);
```

**Characteristics**:
- Smooth slide transition
- 300ms duration
- Ease-in-out curve for natural feel

### State Persistence

**Why use SharedPreferences?**
- Lightweight (single boolean value)
- Fast access
- Persists across app restarts
- No need for complex database

**Alternative approaches**:
```dart
// Option 1: Current approach (SharedPreferences)
final completed = await prefs.getBool('onboarding_completed') ?? false;

// Option 2: Hive (overkill for one boolean)
final box = await Hive.openBox('settings');
final completed = box.get('onboarding_completed', defaultValue: false);

// Option 3: SQLite (too heavy)
final db = await database;
final result = await db.query('settings', where: 'key = ?', whereArgs: ['onboarding']);
```

**Verdict**: SharedPreferences is perfect for this use case.

---

## Customization Guide

### Adding/Removing Pages

**Step 1**: Update content in `onboarding_constants.dart`

```dart
static const List<OnboardingModel> pages = [
  OnboardingModel(
    title: 'Page 1',
    description: 'Description 1',
    image: AppAssets.onboarding1,
  ),
  OnboardingModel(
    title: 'Page 2',
    description: 'Description 2',
    image: AppAssets.onboarding2,
  ),
  // Add more pages here
];
```

**Step 2**: Add images to `assets/images/onboarding/`

**Step 3**: Update `pubspec.yaml`

```yaml
assets:
  - assets/images/onboarding/onboarding1.png
  - assets/images/onboarding/onboarding2.png
  - assets/images/onboarding/onboarding3.png
```

**Step 4**: Update `app_assets.dart`

```dart
class AppAssets {
  static const String onboarding1 = 'assets/images/onboarding/onboarding1.png';
  static const String onboarding2 = 'assets/images/onboarding/onboarding2.png';
  static const String onboarding3 = 'assets/images/onboarding/onboarding3.png';
}
```

### Changing Animation Duration

```dart
// lib/core/config/animation_config.dart
class AnimationConfig {
  // Change splash duration
  static const Duration splashScreenDuration = Duration(seconds: 2);

  // Change fade-in speed
  static const Duration splashAnimationDuration = Duration(milliseconds: 800);

  // Change page transition speed
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);
}
```

### Customizing Colors

```dart
// lib/core/utils/app_colors.dart
class AppColors {
  static const Color primary = Color(0xFFFF6B6B);
  static const Color secondary = Color(0xFF4ECDC4);

  // Used for inactive page indicators
  static const Color grey = Color(0xFF9E9E9E);

  // Splash screen background
  static const Color splashBackground = primary;
}
```

### Changing Typography

```dart
// lib/core/config/app_text_styles.dart
class AppTextStyles {
  static final TextStyle h1 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle h2 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );
}
```

---

## Best Practices

### 1. Keep Onboarding Short
- ✅ 3-5 pages maximum
- ✅ Focus on key features
- ❌ Don't overwhelm users with details

### 2. Make Skip Button Prominent
- ✅ Always visible
- ✅ Easy to tap
- ❌ Don't force users to complete onboarding

### 3. Use Engaging Visuals
- ✅ Custom illustrations
- ✅ Consistent style
- ❌ Avoid stock photos

### 4. Clear Value Proposition
- ✅ Show benefits, not features
- ✅ Use simple language
- ❌ Avoid technical jargon

### 5. Test on Different Devices
```dart
// Use flutter_screenutil for responsive design
Image.asset(
  page.image,
  width: 300.w,  // Adapts to screen size
  height: 300.h,
)
```

---

## Testing

### Manual Testing Checklist

- [ ] Splash screen displays for 3 seconds
- [ ] First-time users see onboarding
- [ ] Returning users skip onboarding
- [ ] Skip button works on all pages
- [ ] Next button advances pages
- [ ] Last page shows "Get Started"
- [ ] Page indicators update correctly
- [ ] Animations are smooth
- [ ] Images load correctly
- [ ] Text is readable on all devices

### Resetting Onboarding

**For testing purposes**, clear SharedPreferences:

```dart
// Option 1: Via code
await AppPrefs().setOnboardingCompleted(false);

// Option 2: Uninstall and reinstall app

// Option 3: Clear app data (Android)
// Settings → Apps → BiteGo → Storage → Clear Data

// Option 4: Delete app (iOS)
// Long press app → Remove App → Delete App
```

---

## Performance Considerations

### Image Optimization

```dart
// Use appropriate image sizes
// Onboarding images: 600x600 @ 2x (1200x1200)
// App logo: 200x200 @ 2x (400x400)

// Compress images to reduce app size
// Use tools like TinyPNG or ImageOptim
```

### Preloading Images

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();

  // Preload onboarding images
  for (final page in OnboardingConstants.pages) {
    precacheImage(AssetImage(page.image), context);
  }
}
```

### Memory Management

```dart
@override
void dispose() {
  _pageController.dispose(); // Always dispose controllers
  super.dispose();
}
```

---

## Accessibility

### Screen Reader Support

```dart
Semantics(
  label: 'Onboarding page ${_currentPage + 1} of ${pages.length}',
  child: OnboardingPageItem(page: pages[_currentPage]),
)
```

### Button Labels

```dart
PrimaryButton(
  text: 'Next',
  semanticsLabel: 'Go to next onboarding page',
  onPressed: _nextPage,
)
```

### Page Indicators

```dart
Semantics(
  label: 'Page ${index + 1} of $pageCount',
  child: AnimatedContainer(...),
)
```

---

## Summary

### Splash Screen
- ✅ 3-second duration
- ✅ Fade-in animation
- ✅ Determines first destination
- ✅ Responsive design

### Onboarding
- ✅ 3 pages with illustrations
- ✅ Page indicators
- ✅ Skip functionality
- ✅ One-time completion
- ✅ Smooth transitions

### Navigation
```
Splash → Onboarding (first time) → Welcome
Splash → Welcome (returning users)
```

### Key Files
- `splash_screen.dart` - Splash implementation
- `onboarding_screen.dart` - Onboarding flow
- `onboarding_constants.dart` - Content
- `app_prefs.dart` - Storage

---

**Next**: See [API_NETWORKING.md](API_NETWORKING.md) for backend integration details.
