# Authentication System

> Complete guide to the authentication system in BiteGo

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Authentication Flows](#authentication-flows)
- [Implementation Details](#implementation-details)
- [UI Components](#ui-components)
- [Error Handling](#error-handling)
- [Security Considerations](#security-considerations)

## Overview

The authentication system in BiteGo handles user registration, login, password recovery, and Google Sign-In. It's built using Clean Architecture with clear separation between presentation, domain, and data layers.

### Tech Stack
- **State Management**: Flutter Bloc (Cubit)
- **Networking**: Dio with dual client architecture
- **Authentication**: Firebase Auth (Google Sign-In)
- **Storage**: SharedPreferences (JWT tokens)
- **Error Handling**: Dartz (Either pattern)

---

## Features

### ✅ Implemented

1. **Email/Password Registration**
   - Full name, email, password validation
   - JWT token storage
   - Automatic login after registration

2. **Email/Password Login**
   - Credential validation
   - JWT token refresh
   - Session persistence

3. **Google Sign-In**
   - Firebase OAuth 2.0 integration
   - Silent sign-in with fallback
   - ID token exchange

4. **Password Recovery**
   - Forgot password flow
   - OTP email verification
   - Password reset

5. **Logout**
   - Token cleanup
   - Session termination
   - Redirect to welcome screen

---

## Architecture

### File Structure

```
lib/features/auth/
├── data/                              # Data Layer
│   ├── models/
│   │   ├── user_model.dart           # JSON ↔ Dart
│   │   ├── auth_result_model.dart
│   │   └── auth_tokens_model.dart
│   ├── repositories/
│   │   └── auth_repository_impl.dart # Repository implementation
│   └── services/
│       ├── auth_service.dart         # Public API calls
│       ├── profile_service.dart      # Protected API calls
│       └── google_auth_service.dart  # Google OAuth handler
├── domain/                            # Domain Layer
│   ├── entities/
│   │   ├── user.dart                 # Business entity
│   │   ├── auth_result.dart
│   │   └── auth_tokens.dart
│   ├── repositories/
│   │   └── auth_repository.dart      # Repository contract
│   └── usecases/
│       ├── register_usecase.dart
│       ├── login_usecase.dart
│       ├── logout_usecase.dart
│       ├── google_sign_in_usecase.dart
│       ├── forgot_password_usecase.dart
│       ├── verify_otp_usecase.dart
│       └── reset_password_usecase.dart
└── presentation/                      # Presentation Layer
    ├── cubit/
    │   ├── auth_cubit.dart           # State management
    │   └── auth_state.dart           # State definitions (11 states)
    ├── screens/
    │   ├── welcome_screen.dart       # Login/Register tabs
    │   ├── forget_password_screen.dart
    │   ├── success_check_email_when_forget_password_screen.dart
    │   ├── enter_password_screen.dart
    │   └── success_change_password_screen.dart
    └── widgets/
        ├── login_form.dart
        ├── register_form.dart
        ├── auth_tabs.dart
        ├── auth_bottom_sheet.dart
        └── google_sign_in_button.dart
```

### Layer Responsibilities

| Layer | Files | Responsibility |
|-------|-------|----------------|
| **Presentation** | Cubit, Screens, Widgets | UI & State Management |
| **Domain** | Entities, UseCases, Repository Interface | Business Logic |
| **Data** | Models, Services, Repository Implementation | API & Storage |

---

## Authentication Flows

### 1. Registration Flow

```
┌──────────────┐
│ User enters  │
│ credentials  │
└──────┬───────┘
       │
       ▼
┌──────────────────┐
│ RegisterForm     │
│ validates input  │
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│ AuthCubit        │
│ .register()      │
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│ RegisterUseCase  │
│ validates data   │
└──────┬───────────┘
       │
       ▼
┌──────────────────────┐
│ AuthRepositoryImpl   │
│ calls AuthService    │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│ AuthService          │
│ POST /auth/register  │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│ Backend API          │
│ creates user         │
│ returns tokens       │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│ AuthRepositoryImpl   │
│ saves tokens to      │
│ SharedPreferences    │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│ AuthCubit emits      │
│ AuthRegistrationSuccess │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│ UI navigates to      │
│ Home Screen          │
└──────────────────────┘
```

#### Code Example

```dart
// 1. User taps "Register" in UI
// lib/features/auth/presentation/widgets/register_form.dart
ElevatedButton(
  onPressed: () {
    context.read<AuthCubit>().register(
      email: emailController.text,
      password: passwordController.text,
      fullName: fullNameController.text,
    );
  },
  child: Text('Register'),
)

// 2. AuthCubit handles registration
// lib/features/auth/presentation/cubit/auth_cubit.dart
Future<void> register({
  required String email,
  required String password,
  required String fullName,
}) async {
  emit(AuthLoading());

  final result = await _registerUseCase(
    email: email,
    password: password,
    fullName: fullName,
  );

  result.fold(
    (error) => emit(AuthError(error)),
    (user) => emit(AuthRegistrationSuccess(user)),
  );
}

// 3. RegisterUseCase validates and delegates
// lib/features/auth/domain/usecases/register_usecase.dart
Future<Either<String, User>> call({
  required String email,
  required String password,
  required String fullName,
}) async {
  if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
    return const Left('All fields are required');
  }

  return await _repository.register(
    email: email,
    password: password,
    fullName: fullName,
  );
}

// 4. Repository calls service and saves tokens
// lib/features/auth/data/repositories/auth_repository_impl.dart
@override
Future<Either<String, User>> register({
  required String email,
  required String password,
  required String fullName,
}) async {
  try {
    final response = await _authService.register(
      email: email,
      password: password,
      fullName: fullName,
    );

    final userModel = UserModel.fromJson(response['user']);
    final tokens = AuthTokensModel.fromJson(response['tokens']);

    await _prefs.setTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    return Right(userModel.toEntity());
  } on DioException catch (e) {
    return Left(ApiErrorHandler.handle(e));
  }
}

// 5. AuthService makes HTTP request
// lib/features/auth/data/services/auth_service.dart
Future<Map<String, dynamic>> register({
  required String email,
  required String password,
  required String fullName,
}) async {
  final response = await dio.post(
    '/auth/register',
    data: {
      'email': email,
      'password': password,
      'full_name': fullName,
    },
  );

  return response.data;
}
```

---

### 2. Login Flow

```
User enters credentials
       ↓
LoginForm validates
       ↓
AuthCubit.login()
       ↓
LoginUseCase validates
       ↓
AuthRepositoryImpl calls AuthService
       ↓
AuthService POST /auth/login
       ↓
Backend returns user + tokens
       ↓
Repository saves tokens
       ↓
Cubit emits AuthAuthenticated
       ↓
Navigate to Home
```

#### API Request/Response

**Request**:
```json
POST /auth/login
{
  "email": "user@example.com",
  "password": "SecurePassword123!"
}
```

**Response**:
```json
{
  "user": {
    "id": "123",
    "email": "user@example.com",
    "full_name": "John Doe"
  },
  "tokens": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
    "expires_in": 3600
  }
}
```

---

### 3. Google Sign-In Flow

```
User taps "Sign in with Google"
       ↓
AuthCubit.signInWithGoogle()
       ↓
GoogleSignInUseCase
       ↓
GoogleAuthService.signInWithGoogle()
       ↓
Firebase Auth + Google Sign In SDK
       ↓
User selects Google account
       ↓
Firebase returns ID token
       ↓
AuthRepositoryImpl sends ID token to backend
       ↓
Backend validates token, returns user + tokens
       ↓
Repository saves tokens
       ↓
Cubit emits AuthGoogleSignInSuccess
       ↓
Navigate to Home
```

#### Implementation

```dart
// lib/features/auth/data/services/google_auth_service.dart
class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithGoogle() async {
    try {
      // Try silent sign-in first
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();

      // If silent sign-in fails, prompt user
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      // Get authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Get ID token to send to backend
      final idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        throw Exception('Failed to get ID token');
      }

      return idToken;
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }
}
```

---

### 4. Password Recovery Flow

#### Step 1: Request OTP

```
User enters email on ForgetPasswordScreen
       ↓
AuthCubit.forgotPassword(email)
       ↓
ForgotPasswordUseCase
       ↓
AuthRepositoryImpl
       ↓
AuthService POST /auth/forgot-password
       ↓
Backend sends OTP email
       ↓
Cubit emits AuthOtpSent
       ↓
Navigate to SuccessCheckEmailScreen
```

**API Request**:
```json
POST /auth/forgot-password
{
  "email": "user@example.com"
}
```

**API Response**:
```json
{
  "message": "OTP sent to email",
  "email": "user@example.com"
}
```

---

#### Step 2: Verify OTP

```
User enters OTP code
       ↓
AuthCubit.verifyOtp(email, otp)
       ↓
VerifyOtpUseCase
       ↓
AuthRepositoryImpl
       ↓
AuthService POST /auth/verify-otp
       ↓
Backend validates OTP
       ↓
Cubit emits AuthOtpVerified
       ↓
Navigate to EnterPasswordScreen
```

**API Request**:
```json
POST /auth/verify-otp
{
  "email": "user@example.com",
  "otp": "123456"
}
```

---

#### Step 3: Reset Password

```
User enters new password
       ↓
AuthCubit.resetPassword(email, newPassword)
       ↓
ResetPasswordUseCase
       ↓
AuthRepositoryImpl
       ↓
AuthService POST /auth/reset-password
       ↓
Backend updates password
       ↓
Cubit emits AuthPasswordResetSuccess
       ↓
Navigate to SuccessChangePasswordScreen
       ↓
User taps "Back to Login"
       ↓
Navigate to WelcomeScreen
```

**API Request**:
```json
POST /auth/reset-password
{
  "email": "user@example.com",
  "new_password": "NewSecurePassword123!"
}
```

---

### 5. Logout Flow

```
User taps "Logout"
       ↓
AuthCubit.logout()
       ↓
LogoutUseCase
       ↓
AuthRepositoryImpl
       ↓
Clear tokens from SharedPreferences
       ↓
Cubit emits AuthUnauthenticated
       ↓
Navigate to WelcomeScreen
```

---

## Implementation Details

### Token Management

**Storage Location**: [lib/core/storage/shared_prefs.dart](../lib/core/storage/shared_prefs.dart)

```dart
class AppPrefs {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';

  // Save tokens
  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
  }

  // Get access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  // Clear all tokens (logout)
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
  }
}
```

---

### Dual Client Architecture

**Problem**: Registration was failing because expired tokens were being sent to public endpoints.

**Solution**: Separate HTTP clients for public and protected endpoints.

#### Public Client (No Auth)

```dart
// lib/core/networking/dio_client.dart
static Dio createPublicDio() {
  final dio = Dio(BaseOptions(
    baseUrl: FlavorConfig.current.apiBaseUrl,
    connectTimeout: TimingConfig.connectTimeout,
    receiveTimeout: TimingConfig.receiveTimeout,
  ));

  // NO auth interceptor
  if (FlavorConfig.current.enableLogging) {
    dio.interceptors.add(LogInterceptor(...));
  }

  return dio;
}
```

**Used by**:
- `AuthService` (register, login, password recovery)

---

#### Protected Client (With Auth)

```dart
static Dio createProtectedDio() {
  final dio = Dio(BaseOptions(
    baseUrl: FlavorConfig.current.apiBaseUrl,
    connectTimeout: TimingConfig.connectTimeout,
    receiveTimeout: TimingConfig.receiveTimeout,
  ));

  // Add auth interceptor (automatically injects Bearer token)
  dio.interceptors.add(AuthInterceptor());

  if (FlavorConfig.current.enableLogging) {
    dio.interceptors.add(LogInterceptor(...));
  }

  return dio;
}
```

**Used by**:
- `ProfileService` (getProfile, updateProfile)
- Future: `CartService`, `OrderService`, etc.

---

### Auth Interceptor

```dart
class AuthInterceptor extends Interceptor {
  final AppPrefs _prefs = AppPrefs();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _prefs.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired, try to refresh
      final refreshed = await _refreshToken();

      if (refreshed) {
        // Retry original request
        final options = err.requestOptions;
        final response = await Dio().request(
          options.path,
          options: Options(method: options.method),
          data: options.data,
          queryParameters: options.queryParameters,
        );

        return handler.resolve(response);
      }
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    // TODO: Implement token refresh logic
    return false;
  }
}
```

---

## UI Components

### WelcomeScreen

**Location**: [lib/features/auth/presentation/screens/welcome_screen.dart](../lib/features/auth/presentation/screens/welcome_screen.dart)

**Features**:
- Tab navigation (Login / Register)
- Google Sign-In button
- Form validation
- Error handling

```dart
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(...),
      child: Scaffold(
        body: Column(
          children: [
            AuthTabs(), // Login / Register tabs
            Expanded(
              child: TabBarView(
                children: [
                  LoginForm(),
                  RegisterForm(),
                ],
              ),
            ),
            GoogleSignInButton(),
          ],
        ),
      ),
    );
  }
}
```

---

### LoginForm

**Location**: [lib/features/auth/presentation/widgets/login_form.dart](../lib/features/auth/presentation/widgets/login_form.dart)

**Features**:
- Email validation
- Password validation
- Loading state
- Error display

```dart
class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is AuthAuthenticated) {
          context.go('/home');
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Column(
          children: [
            CustomTextField(
              label: 'Email',
              enabled: !isLoading,
            ),
            CustomPasswordField(
              label: 'Password',
              enabled: !isLoading,
            ),
            PrimaryButton(
              text: 'Login',
              isLoading: isLoading,
              onPressed: () {
                context.read<AuthCubit>().login(
                  email: emailController.text,
                  password: passwordController.text,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
```

---

### RegisterForm

**Location**: [lib/features/auth/presentation/widgets/register_form.dart](../lib/features/auth/presentation/widgets/register_form.dart)

**Validation**:
- Full name (minimum 2 words)
- Email (valid format)
- Password (8+ chars, uppercase, number, special char)

---

### GoogleSignInButton

**Location**: [lib/features/auth/presentation/widgets/google_sign_in_button.dart](../lib/features/auth/presentation/widgets/google_sign_in_button.dart)

```dart
class GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthGoogleSignInSuccess) {
          context.go('/home');
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return OutlinedButton.icon(
          onPressed: isLoading
              ? null
              : () => context.read<AuthCubit>().signInWithGoogle(),
          icon: SvgPicture.asset('assets/icons/google.svg'),
          label: Text('Sign in with Google'),
        );
      },
    );
  }
}
```

---

## Error Handling

### API Error Mapping

**Location**: [lib/core/networking/api_error_handler.dart](../lib/core/networking/api_error_handler.dart)

```dart
class ApiErrorHandler {
  static String handle(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Please try again.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }

    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        return _extractErrorMessage(error) ?? 'Invalid request';
      case 401:
        return 'Not authorized. Please login again.';
      case 404:
        return 'Resource not found';
      case 409:
        return 'Email already exists. Please login instead.';
      case 422:
        return _extractErrorMessage(error) ?? 'Validation failed';
      case 500:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return 'An unexpected error occurred';
    }
  }

  static String? _extractErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message'] ?? data['error'];
    }
    return null;
  }
}
```

### Error States

```dart
// Show error in UI
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
)
```

---

## Security Considerations

### 1. Token Storage

✅ **Current**: SharedPreferences
⚠️ **Recommendation**: Use [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) for production

```dart
// Secure storage example
final storage = FlutterSecureStorage();
await storage.write(key: 'access_token', value: token);
final token = await storage.read(key: 'access_token');
```

### 2. Password Validation

**Current requirements**:
- Minimum 8 characters
- At least one uppercase letter
- At least one number
- At least one special character

**Location**: [lib/core/validation/password_input.dart](../lib/core/validation/password_input.dart)

### 3. HTTPS Only

All API requests use HTTPS in production:

```dart
static const String prodApiBaseUrl = 'https://api.bitego.com';
static const String devApiBaseUrl = 'https://dev-api.bitego.com';
```

### 4. Token Expiration

- Access tokens expire after 1 hour (3600 seconds)
- Refresh tokens used for obtaining new access tokens
- 401 responses trigger automatic token refresh

### 5. Google Sign-In Security

- ID tokens validated server-side
- Firebase handles OAuth flow securely
- No client-side token generation

---

## Testing

### Unit Tests

```dart
void main() {
  group('LoginUseCase', () {
    late MockAuthRepository mockRepository;
    late LoginUseCase loginUseCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      loginUseCase = LoginUseCase(mockRepository);
    });

    test('returns error when email is empty', () async {
      final result = await loginUseCase('', 'password');

      expect(result.isLeft(), true);
      result.fold(
        (error) => expect(error, 'Email and password are required'),
        (_) => fail('Should return error'),
      );
    });

    test('calls repository when credentials are valid', () async {
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(User(...)));

      await loginUseCase('test@example.com', 'password123');

      verify(() => mockRepository.login('test@example.com', 'password123'))
          .called(1);
    });
  });
}
```

---

## Summary

### Key Components

| Component | Responsibility |
|-----------|---------------|
| **AuthCubit** | State management (11 states) |
| **UseCases** | Business logic validation |
| **AuthRepository** | Data access contract |
| **AuthService** | HTTP API calls (public endpoints) |
| **GoogleAuthService** | Firebase Google Sign-In |
| **AppPrefs** | Token storage |

### State Flow

```
Initial → Loading → Success/Error
```

### API Endpoints

```
POST /auth/register          → Register new user
POST /auth/login             → Login with credentials
POST /auth/google-signin     → Google OAuth
POST /auth/refresh           → Refresh access token
POST /auth/forgot-password   → Request OTP
POST /auth/verify-otp        → Validate OTP
POST /auth/reset-password    → Set new password
```

---

**Next**: See [ONBOARDING_SPLASH.md](ONBOARDING_SPLASH.md) for first-launch experience.
