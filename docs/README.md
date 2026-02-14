# BiteGo - Restaurant App Documentation

> A modern Flutter restaurant ordering application built with Clean Architecture, SOLID principles, and production-ready practices.

## Table of Contents

- [Project Overview](#project-overview)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Documentation Index](#documentation-index)
- [Project Statistics](#project-statistics)
- [Tech Stack](#tech-stack)

## Project Overview

**BiteGo** is a Flutter-based restaurant ordering application that demonstrates enterprise-level architecture and best practices. The app is built with:

- ✅ **Clean Architecture** - Strict separation of concerns across Data, Domain, and Presentation layers
- ✅ **SOLID Principles** - Single Responsibility, Dependency Inversion, Interface Segregation
- ✅ **State Management** - Flutter Bloc (Cubit pattern) for predictable state handling
- ✅ **Dual API Client Pattern** - Separate public/protected HTTP clients for security
- ✅ **Functional Error Handling** - Using `Either<L, R>` pattern from Dartz
- ✅ **Internationalization** - Support for English, French, and Arabic
- ✅ **Responsive Design** - Adaptive UI using flutter_screenutil
- ✅ **Firebase Integration** - Google Sign-In with Firebase Auth

## Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Firebase project configured
- Android Studio / VS Code

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd restaurant_app

# Install dependencies
flutter pub get

# Run in development flavor
flutter run --flavor dev -t lib/main_dev.dart

# Run in production flavor
flutter run --flavor prod -t lib/main_prod.dart
```

### Firebase Setup
1. Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
2. Configure Firebase in the Firebase Console
3. Enable Email/Password and Google authentication methods

## Architecture

### Folder Structure

```
lib/
├── core/                    # Shared infrastructure
│   ├── common_ui/          # Reusable widgets
│   ├── config/             # Configuration files
│   ├── networking/         # HTTP clients & API services
│   ├── routing/            # Navigation setup
│   ├── storage/            # Local persistence
│   └── validation/         # Input validators
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── onboarding/        # Onboarding flow
│   ├── splash/            # Splash screen
│   └── home/              # Home screen
└── l10n/                  # Localization files
```

### Layer Responsibilities

| Layer | Responsibility | Examples |
|-------|---------------|----------|
| **Presentation** | UI & State Management | Cubits, Screens, Widgets |
| **Domain** | Business Logic | Entities, UseCases, Repository Interfaces |
| **Data** | Data Sources | API Services, Models, Repository Implementations |

## Documentation Index

Comprehensive documentation is organized by topic:

### Core Architecture
- [**Clean Architecture Guide**](CLEAN_ARCHITECTURE.md) - Layer separation, dependency rules, data flow
- [**SOLID Principles**](SOLID_PRINCIPLES.md) - How SOLID is applied throughout the codebase
- [**State Management with Cubit**](STATE_MANAGEMENT.md) - Flutter Bloc, state patterns, best practices

### Features
- [**Authentication System**](AUTHENTICATION.md) - Login, Register, Google Sign-In, Password Recovery
- [**Onboarding & Splash**](ONBOARDING_SPLASH.md) - First-launch experience, animations
- [**API & Networking**](API_NETWORKING.md) - Dual client pattern, error handling, endpoints

### Configuration
- [**Flavors & Environments**](FLAVORS.md) - Dev/Prod configurations
- [**Localization (i18n)**](LOCALIZATION.md) - Multi-language support
- [**Theming**](THEMING.md) - Light/Dark themes, colors, typography

## Project Statistics

| Metric | Count |
|--------|-------|
| **Total Dart Files** | 119 |
| **Features Implemented** | 4 (Auth, Onboarding, Splash, Home) |
| **Authentication States** | 11 distinct states |
| **Configuration Files** | 15+ specialized configs |
| **Supported Languages** | 3 (EN, FR, AR) |
| **API Endpoints Defined** | 13+ |
| **UI Screens** | 5 major screens |
| **Reusable Widgets** | 15+ custom components |

## Tech Stack

### Core Framework
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language

### State Management
- **flutter_bloc** (8.1.3) - Business logic components
- **equatable** (2.0.8) - Value equality for states

### Networking
- **dio** (5.9.0) - HTTP client
- **dartz** (0.10.1) - Functional programming (Either)

### Firebase
- **firebase_core** (4.4.0) - Firebase initialization
- **firebase_auth** (6.1.4) - Authentication
- **google_sign_in** (7.2.0) - Google OAuth

### Navigation & Routing
- **go_router** (17.0.1) - Declarative routing

### UI & Design
- **flutter_screenutil** (5.9.3) - Responsive design
- **flutter_svg** (2.2.3) - SVG rendering
- **lottie** (3.3.2) - Animations

### Storage
- **shared_preferences** (2.5.4) - Local key-value storage

### Validation
- **formz** (0.8.0) - Form input validation

### Utilities
- **logger** (2.5.0) - Structured logging
- **intl** (0.20.2) - Internationalization

## Key Features

### Implemented ✅
- ✅ User Registration (Email/Password)
- ✅ User Login
- ✅ Google Sign-In (Firebase OAuth)
- ✅ Password Recovery (Forgot Password)
- ✅ OTP Verification
- ✅ Password Reset
- ✅ Logout
- ✅ Onboarding Flow
- ✅ Animated Splash Screen
- ✅ Multi-language Support (EN, FR, AR)
- ✅ Light/Dark Theme
- ✅ Responsive Design

### Planned 📋
- 📋 Product Catalog
- 📋 Category Browsing
- 📋 Shopping Cart
- 📋 Order Creation
- 📋 Order History
- 📋 Delivery Address Management
- 📋 Product Reviews
- 📋 Payment Integration

## Development Guidelines

### Code Style
- Follow Dart [effective-dart](https://dart.dev/guides/language/effective-dart) conventions
- Use `analysis_options.yaml` for linting rules
- Prefer immutability and value objects
- Use `const` constructors where possible

### Git Workflow
- **main** - Production-ready code
- **develop** - Integration branch
- **feature/** - Feature branches
- **bugfix/** - Bug fix branches

### Testing Strategy
```
lib/
  └── feature/
      ├── data/          → Unit tests for repositories
      ├── domain/        → Unit tests for use cases
      └── presentation/  → Widget & Cubit tests
```

## Environment Configuration

### Development (`main_dev.dart`)
- Debug logging enabled
- Development API base URL
- Verbose error messages

### Production (`main_prod.dart`)
- Logging disabled
- Production API base URL
- User-friendly error messages

## API Integration

### Base URLs
- **Dev**: `https://dev-api.bitego.com` (example)
- **Prod**: `https://api.bitego.com` (example)

### Authentication Flow
```
1. User registers/logs in
2. Backend returns access token + refresh token
3. Tokens stored in SharedPreferences
4. Protected endpoints automatically inject Bearer token
5. Token refresh on 401 Unauthorized
```

## Logging

Centralized logging via `AppLogger`:

```dart
AppLogger.debug('Debug message');
AppLogger.info('Info message');
AppLogger.warning('Warning message');
AppLogger.error('Error message', error: e, stackTrace: st);
AppLogger.apiRequest('/endpoint', method: 'POST');
AppLogger.auth('User logged in');
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

[Add your license here]

## Contact & Support

- **Documentation**: See `/docs` folder for detailed guides
- **Issues**: Report bugs via GitHub Issues
- **Questions**: Contact [your-email@example.com]

---

**Last Updated**: February 2026
**Current Branch**: `step/auth`
**Version**: 0.1.0-dev
