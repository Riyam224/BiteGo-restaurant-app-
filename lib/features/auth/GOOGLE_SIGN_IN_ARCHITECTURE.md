# Google Sign-In Architecture Documentation

## Overview
This document explains the Google Sign-In implementation following **Clean Architecture** and **SOLID principles**.

## Architecture Layers

### 1. **Data Layer** (Outermost)
Handles external data sources and services.

#### GoogleAuthService (`data/services/google_auth_service.dart`)
- **Responsibility**: Firebase Authentication with Google Sign-In (Single Responsibility Principle)
- **Purpose**: Handles the OAuth flow with Google and Firebase
- **Key Methods**:
  - `signInWithGoogle()`: Authenticates user with Google and returns Firebase ID token
  - `signOut()`: Signs out from both Google and Firebase
- **Notes**:
  - Uses google_sign_in v7.0+ API (singleton pattern with `GoogleSignIn.instance`)
  - Only uses `idToken` (v7.0+ doesn't provide accessToken)

#### AuthService (`data/services/auth_service.dart`)
- **Responsibility**: Backend API authentication endpoints
- **New Method**: `googleSignIn(idToken)` - Sends Firebase ID token to backend

#### AuthRepositoryImpl (`data/repositories/auth_repository_impl.dart`)
- **Responsibility**: Implements domain repository interface
- **Dependencies**:
  - `AuthService` (for backend API calls)
  - `GoogleAuthService` (for Firebase authentication)
- **Implementation**:
  - Coordinates between Firebase auth and backend
  - Stores tokens in SharedPreferences
  - Converts data models to domain entities

---

### 2. **Domain Layer** (Core/Business Logic)
Contains business rules and is independent of frameworks.

#### AuthRepository Interface (`domain/repositories/auth_repository.dart`)
- **New Method**: `signInWithGoogle(): Future<Either<String, AuthResult>>`
- **Purpose**: Defines contract for authentication operations
- **Follows**: Dependency Inversion Principle (DIP) - depend on abstractions

#### GoogleSignInUseCase (`domain/usecases/google_sign_in_usecase.dart`)
- **Responsibility**: Encapsulates Google Sign-In business logic
- **Follows**: Single Responsibility Principle (SRP)
- **Dependencies**: `AuthRepository` (interface, not implementation)

#### Entities
- `User`: User information
- `AuthResult`: Contains user and authentication tokens
- `AuthTokens`: Access and refresh tokens

---

### 3. **Presentation Layer** (UI/State Management)
Handles UI and user interactions.

#### AuthState (`presentation/cubit/auth_state.dart`)
- **New State**: `AuthGoogleSignInSuccess` - Specific state for Google Sign-In
- **Purpose**: Distinguishes between regular login and Google Sign-In

#### AuthCubit (`presentation/cubit/auth_cubit.dart`)
- **New Method**: `signInWithGoogle()` - Triggers Google Sign-In flow
- **Dependencies**: `GoogleSignInUseCase` (via constructor injection)
- **Follows**: Dependency Inversion Principle

#### UI Widgets
- `GoogleSignInButton`: Reusable button component
- `LoginForm`: Updated to call `authCubit.signInWithGoogle()`
- `RegisterForm`: Updated to call `authCubit.signInWithGoogle()`

---

### 4. **Dependency Injection** (`di/auth_dependencies.dart`)
- **Pattern**: Factory methods for creating dependencies
- **New Dependencies**:
  - `GoogleAuthService`
  - `GoogleSignInUseCase`
- **Follows**: Dependency Injection pattern for loose coupling

---

## SOLID Principles Applied

### Single Responsibility Principle (SRP)
- ✅ `GoogleAuthService` - Only handles Firebase/Google authentication
- ✅ `AuthService` - Only handles backend API calls
- ✅ `GoogleSignInUseCase` - Only contains Google Sign-In business logic

### Open/Closed Principle (OCP)
- ✅ New functionality (Google Sign-In) added without modifying existing code
- ✅ Extended `AuthRepository` interface with new method
- ✅ Added new use case without changing existing ones

### Liskov Substitution Principle (LSP)
- ✅ `AuthRepositoryImpl` correctly implements `AuthRepository` interface
- ✅ All implementations are substitutable for their abstractions

### Interface Segregation Principle (ISP)
- ✅ Focused interfaces (`AuthRepository` has only auth-related methods)
- ✅ Use cases have single, specific purposes

### Dependency Inversion Principle (DIP)
- ✅ High-level modules (UseCases, Cubit) depend on abstractions (Repository interface)
- ✅ Low-level modules (RepositoryImpl) implement abstractions
- ✅ All dependencies injected via constructors

---

## Authentication Flow

### Google Sign-In Flow:
```
1. User taps "Sign in with Google" button
   ↓
2. UI calls authCubit.signInWithGoogle()
   ↓
3. Cubit calls GoogleSignInUseCase
   ↓
4. UseCase calls AuthRepository.signInWithGoogle()
   ↓
5. Repository calls GoogleAuthService.signInWithGoogle()
   ↓
6. GoogleAuthService:
   - Initializes GoogleSignIn.instance
   - Attempts lightweight authentication (silent)
   - Falls back to interactive authentication
   - Gets Firebase ID token
   ↓
7. Repository sends Firebase ID token to backend via AuthService
   ↓
8. Backend validates token and returns user data + JWT tokens
   ↓
9. Repository stores tokens in SharedPreferences
   ↓
10. Cubit emits AuthGoogleSignInSuccess state
   ↓
11. UI shows success dialog and navigates to home
```

---

## Key Files Modified/Created

### Created:
- `/lib/features/auth/data/services/google_auth_service.dart`
- `/lib/features/auth/domain/usecases/google_sign_in_usecase.dart`
- `/lib/features/auth/presentation/cubit/auth_state.dart` (added state)

### Modified:
- `/lib/main.dart` - Added Firebase initialization
- `/lib/core/networking/endpoints.dart` - Added `/auth/google` endpoint
- `/lib/features/auth/domain/repositories/auth_repository.dart` - Added method
- `/lib/features/auth/data/repositories/auth_repository_impl.dart` - Implemented method
- `/lib/features/auth/data/services/auth_service.dart` - Added endpoint method
- `/lib/features/auth/presentation/cubit/auth_cubit.dart` - Added method
- `/lib/features/auth/presentation/widgets/login_form.dart` - Wired button
- `/lib/features/auth/presentation/widgets/register_form.dart` - Wired button
- `/lib/features/auth/di/auth_dependencies.dart` - Added dependencies
- `/pubspec.yaml` - Added `firebase_core: ^4.4.0`

---

## Backend API Contract

### Endpoint: POST `/auth/google`
**Request Body:**
```json
{
  "id_token": "Firebase_ID_Token_Here"
}
```

**Response:**
```json
{
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "User Name",
    "phone": null,
    "avatar": "https://..."
  },
  "tokens": {
    "access": "jwt_access_token",
    "refresh": "jwt_refresh_token"
  }
}
```

---

## Testing Considerations

1. **Unit Tests**: Test each layer independently
   - Mock `GoogleAuthService` in repository tests
   - Mock `AuthRepository` in use case tests
   - Mock `GoogleSignInUseCase` in cubit tests

2. **Integration Tests**: Test flow from UI to repository

3. **Widget Tests**: Test UI components and state handling

---

## Important Notes

### google_sign_in v7.0+ Changes
- Uses singleton pattern: `GoogleSignIn.instance`
- Methods changed:
  - `signIn()` → `authenticate()`
  - `signInSilently()` → `attemptLightweightAuthentication()`
  - `signOut()` → `disconnect()`
- Only provides `idToken` (no `accessToken`)
- Requires calling `initialize()` before authentication

### Firebase Configuration
- Firebase is initialized in `main.dart` before app startup
- Firebase options configured in `firebase_options.dart` (generated by FlutterFire CLI)
- Android and iOS clients configured with proper OAuth credentials

---

## Sources
- [Google Sign-In Flutter Migration Guide (v7.0+)](https://isaacadariku.medium.com/google-sign-in-flutter-migration-guide-pre-7-0-versions-to-v7-version-cdc9efd7f182)
- [google_sign_in Package Documentation](https://pub.dev/packages/google_sign_in)
