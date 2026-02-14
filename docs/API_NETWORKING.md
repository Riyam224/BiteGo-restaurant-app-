# API & Networking Architecture

> Complete guide to HTTP client configuration, API integration, and networking patterns in BiteGo

## Table of Contents

- [Overview](#overview)
- [Dual Client Architecture](#dual-client-architecture)
- [API Services](#api-services)
- [Error Handling](#error-handling)
- [Endpoints](#endpoints)
- [Request/Response Flow](#requestresponse-flow)
- [Configuration](#configuration)
- [Best Practices](#best-practices)

## Overview

BiteGo uses a sophisticated networking architecture that separates public and protected API endpoints using a dual HTTP client pattern. This ensures secure token management and prevents authentication errors.

### Key Technologies
- **HTTP Client**: Dio (5.9.0)
- **Interceptors**: Auth, Logging
- **Error Handling**: Custom ApiErrorHandler
- **Configuration**: Flavor-based (dev/prod)

### Architecture Principles
- ✅ **Separation of Concerns**: Public vs Protected clients
- ✅ **DRY**: Reusable base services
- ✅ **Error Handling**: Centralized error mapping
- ✅ **Logging**: Debug-only request/response logs
- ✅ **Security**: Automatic Bearer token injection

---

## Dual Client Architecture

### The Problem (Before)

**Issue**: Registration failed when expired tokens existed in SharedPreferences.

**Root Cause**:
```dart
// Single client with auth interceptor
class DioClient {
  static Dio create() {
    final dio = Dio(...);
    dio.interceptors.add(AuthInterceptor()); // ALWAYS adds token!
    return dio;
  }
}

// AuthService using this client
class AuthService {
  final Dio dio;

  Future<void> register(...) async {
    await dio.post('/auth/register', ...);
    // ❌ Sends expired token even for public endpoint!
    // ❌ Backend rejects with 401 Unauthorized
  }
}
```

**What happened**:
1. User had expired token from previous session
2. AuthInterceptor added token to ALL requests (including register)
3. Backend received register request with expired token
4. Backend returned 401 Unauthorized
5. Registration failed

---

### The Solution (After)

**Dual Client Pattern**: Separate HTTP clients for different endpoint types.

```
┌─────────────────────────────────────────────┐
│            Dio Client Factory               │
│                                             │
│  ┌───────────────────┬───────────────────┐ │
│  │   Public Client   │  Protected Client │ │
│  │                   │                   │ │
│  │  ❌ NO Auth       │  ✅ Auth          │ │
│  │  ✅ Logging       │  ✅ Logging       │ │
│  └─────────┬─────────┴────────┬──────────┘ │
└────────────┼──────────────────┼─────────────┘
             │                  │
             ▼                  ▼
    ┌────────────────┐  ┌────────────────┐
    │ PublicApiService│  │BaseApiService  │
    │                │  │                │
    │ - register     │  │ - getProfile   │
    │ - login        │  │ - getCart      │
    │ - forgotPwd    │  │ - getOrders    │
    └────────────────┘  └────────────────┘
```

---

### Implementation

**Location**: [lib/core/networking/dio_client.dart](../lib/core/networking/dio_client.dart)

```dart
class DioClient {
  // ===== PUBLIC CLIENT (No Authentication) =====
  static Dio createPublicDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: FlavorConfig.current.apiBaseUrl,
        connectTimeout: TimingConfig.connectTimeout,
        receiveTimeout: TimingConfig.receiveTimeout,
        sendTimeout: TimingConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging interceptor (NO auth interceptor)
    if (FlavorConfig.current.enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => AppLogger.debug('[DIO] $obj'),
        ),
      );
    }

    return dio;
  }

  // ===== PROTECTED CLIENT (With Authentication) =====
  static Dio createProtectedDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: FlavorConfig.current.apiBaseUrl,
        connectTimeout: TimingConfig.connectTimeout,
        receiveTimeout: TimingConfig.receiveTimeout,
        sendTimeout: TimingConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add auth interceptor (automatically injects Bearer token)
    dio.interceptors.add(AuthInterceptor());

    // Add logging interceptor
    if (FlavorConfig.current.enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => AppLogger.debug('[DIO] $obj'),
        ),
      );
    }

    return dio;
  }
}
```

### Auth Interceptor

**Location**: [lib/core/networking/auth_interceptor.dart](../lib/core/networking/auth_interceptor.dart)

```dart
class AuthInterceptor extends Interceptor {
  final AppPrefs _prefs = AppPrefs();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get token from storage
    final token = await _prefs.getAccessToken();

    // Add Bearer token to headers
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      AppLogger.debug('🔐 Added auth token to request: ${options.path}');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized (expired token)
    if (err.response?.statusCode == 401) {
      AppLogger.warning('⚠️ 401 Unauthorized - Token expired');

      // Try to refresh token
      final refreshed = await _refreshToken();

      if (refreshed) {
        // Retry original request with new token
        final newToken = await _prefs.getAccessToken();
        final options = err.requestOptions;

        options.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await Dio().request(
            options.path,
            options: Options(
              method: options.method,
              headers: options.headers,
            ),
            data: options.data,
            queryParameters: options.queryParameters,
          );

          return handler.resolve(response);
        } catch (e) {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Failed to refresh token',
            ),
          );
        }
      }
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _prefs.getRefreshToken();

      if (refreshToken == null) return false;

      // Call refresh endpoint
      final response = await Dio().post(
        '${FlavorConfig.current.apiBaseUrl}/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        await _prefs.setTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        AppLogger.info('✅ Token refreshed successfully');
        return true;
      }

      return false;
    } catch (e) {
      AppLogger.error('❌ Token refresh failed', error: e);
      return false;
    }
  }
}
```

---

## API Services

### Base Service Classes

#### PublicApiService (Unauthenticated Endpoints)

**Location**: [lib/core/networking/public_api_service.dart](../lib/core/networking/public_api_service.dart)

```dart
abstract class PublicApiService {
  final Dio dio;

  PublicApiService(this.dio);

  // Common error handling
  Future<T> handleRequest<T>(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
```

**Used by**:
- `AuthService` (register, login, password recovery)

---

#### BaseApiService (Authenticated Endpoints)

**Location**: [lib/core/networking/base_api_service.dart](../lib/core/networking/base_api_service.dart)

```dart
abstract class BaseApiService {
  final Dio dio;

  BaseApiService(this.dio);

  // Common error handling
  Future<T> handleRequest<T>(
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
```

**Used by**:
- `ProfileService` (getProfile, updateProfile)
- Future: `CartService`, `OrderService`, etc.

---

### Service Implementations

#### AuthService (Public)

**Location**: [lib/features/auth/data/services/auth_service.dart](../lib/features/auth/data/services/auth_service.dart)

```dart
class AuthService extends PublicApiService {
  AuthService(super.dio);

  // Register new user
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

  // Login with credentials
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return response.data;
  }

  // Google Sign-In
  Future<Map<String, dynamic>> googleSignIn({
    required String idToken,
  }) async {
    final response = await dio.post(
      '/auth/google-signin',
      data: {
        'id_token': idToken,
      },
    );

    return response.data;
  }

  // Forgot password (request OTP)
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await dio.post(
      '/auth/forgot-password',
      data: {
        'email': email,
      },
    );

    return response.data;
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await dio.post(
      '/auth/verify-otp',
      data: {
        'email': email,
        'otp': otp,
      },
    );

    return response.data;
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final response = await dio.post(
      '/auth/reset-password',
      data: {
        'email': email,
        'new_password': newPassword,
      },
    );

    return response.data;
  }

  // Refresh token
  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    final response = await dio.post(
      '/auth/refresh',
      data: {
        'refresh_token': refreshToken,
      },
    );

    return response.data;
  }
}
```

---

#### ProfileService (Protected)

**Location**: [lib/features/auth/data/services/profile_service.dart](../lib/features/auth/data/services/profile_service.dart)

```dart
class ProfileService extends BaseApiService {
  ProfileService(super.dio);

  // Get user profile (requires authentication)
  Future<Map<String, dynamic>> getProfile() async {
    final response = await dio.get('/profile');
    return response.data;
  }

  // Update profile
  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
  }) async {
    final response = await dio.put(
      '/profile',
      data: {
        'full_name': fullName,
      },
    );

    return response.data;
  }
}
```

---

#### GoogleAuthService

**Location**: [lib/features/auth/data/services/google_auth_service.dart](../lib/features/auth/data/services/google_auth_service.dart)

```dart
class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInWithGoogle() async {
    try {
      // Try silent sign-in first
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();

      // If silent sign-in fails, show account picker
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in cancelled by user');
      }

      // Get authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
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
        throw Exception('Failed to get ID token from Firebase');
      }

      AppLogger.info('✅ Google sign-in successful');
      return idToken;
    } catch (e) {
      AppLogger.error('❌ Google sign-in failed', error: e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _firebaseAuth.signOut(),
    ]);
  }
}
```

---

## Error Handling

### ApiErrorHandler

**Location**: [lib/core/networking/api_error_handler.dart](../lib/core/networking/api_error_handler.dart)

```dart
class ApiErrorHandler {
  static String handle(DioException error) {
    AppLogger.error('❌ API Error', error: error);

    // Connection timeout
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Connection timed out. Please check your internet connection.';
    }

    // No internet connection
    if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please connect to the internet and try again.';
    }

    // HTTP error responses
    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        return _extractErrorMessage(error) ?? 'Bad request. Please check your input.';

      case 401:
        return 'Session expired. Please login again.';

      case 403:
        return 'Access denied. You don\'t have permission to perform this action.';

      case 404:
        return 'Resource not found.';

      case 409:
        return _extractErrorMessage(error) ?? 'Conflict. Email already exists.';

      case 422:
        return _extractErrorMessage(error) ?? 'Validation failed. Please check your input.';

      case 500:
      case 502:
      case 503:
        return 'Server error. Please try again later.';

      case 504:
        return 'Gateway timeout. The server is taking too long to respond.';

      default:
        return _extractErrorMessage(error) ?? 'An unexpected error occurred. Please try again.';
    }
  }

  // Extract error message from response
  static String? _extractErrorMessage(DioException error) {
    try {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        // Try common error message keys
        return data['message'] ??
            data['error'] ??
            data['detail'] ??
            data['msg'];
      }

      if (data is String) {
        return data;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
```

### Error Response Examples

#### 400 Bad Request
```json
{
  "message": "Invalid email format",
  "errors": {
    "email": ["Email must be a valid email address"]
  }
}
```

#### 401 Unauthorized
```json
{
  "message": "Token expired or invalid",
  "code": "TOKEN_EXPIRED"
}
```

#### 409 Conflict
```json
{
  "message": "Email already exists",
  "code": "EMAIL_ALREADY_EXISTS"
}
```

#### 422 Validation Error
```json
{
  "message": "Validation failed",
  "errors": {
    "password": ["Password must be at least 8 characters"],
    "email": ["Email is required"]
  }
}
```

---

## Endpoints

### Endpoint Constants

**Location**: [lib/core/constants/api_endpoints.dart](../lib/core/constants/api_endpoints.dart)

```dart
class ApiEndpoints {
  // ===== Authentication Endpoints (Public) =====
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String googleSignIn = '/auth/google-signin';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh';

  // ===== Profile Endpoints (Protected) =====
  static const String getProfile = '/profile';
  static const String updateProfile = '/profile';

  // ===== Category Endpoints (Protected) =====
  static const String getCategories = '/categories/';

  // ===== Product Endpoints (Protected) =====
  static const String getProducts = '/products/';
  static const String getProductById = '/products/{id}/';

  // ===== Cart Endpoints (Protected) =====
  static const String getCart = '/cart/';
  static const String addToCart = '/cart/add/';
  static const String updateCartItem = '/cart/update/';
  static const String removeFromCart = '/cart/remove/';
  static const String clearCart = '/cart/clear/';

  // ===== Order Endpoints (Protected) =====
  static const String getOrders = '/orders/';
  static const String getOrderById = '/orders/{id}/';
  static const String createOrder = '/orders/create/';

  // ===== Address Endpoints (Protected) =====
  static const String getAddresses = '/addresses/';
  static const String addAddress = '/addresses/add/';
  static const String updateAddress = '/addresses/{id}/';
  static const String deleteAddress = '/addresses/{id}/';

  // ===== Review Endpoints (Protected) =====
  static const String getReviews = '/reviews/';
  static const String addReview = '/reviews/add/';
}
```

---

## Request/Response Flow

### Complete Request Flow

```
┌──────────────────────┐
│   Presentation       │
│   (Cubit)            │
└──────────┬───────────┘
           │ Calls UseCase
           ▼
┌──────────────────────┐
│   Domain             │
│   (UseCase)          │
└──────────┬───────────┘
           │ Calls Repository
           ▼
┌──────────────────────┐
│   Data               │
│   (Repository Impl)  │
└──────────┬───────────┘
           │ Calls Service
           ▼
┌──────────────────────┐
│   Data               │
│   (Service)          │
└──────────┬───────────┘
           │ Uses Dio Client
           ▼
┌──────────────────────┐
│   Dio Interceptors   │
│   - Auth (if protected)
│   - Logging          │
└──────────┬───────────┘
           │ HTTP Request
           ▼
┌──────────────────────┐
│   Backend API        │
└──────────┬───────────┘
           │ HTTP Response
           ▼
┌──────────────────────┐
│   Dio Interceptors   │
│   - Error handling   │
└──────────┬───────────┘
           │ Response/Error
           ▼
┌──────────────────────┐
│   Service            │
│   (throws on error)  │
└──────────┬───────────┘
           │ Model or Error
           ▼
┌──────────────────────┐
│   Repository         │
│   (converts to Entity)
└──────────┬───────────┘
           │ Either<Error, Entity>
           ▼
┌──────────────────────┐
│   UseCase            │
│   (returns Either)   │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Cubit              │
│   (emits State)      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   UI                 │
│   (rebuilds)         │
└──────────────────────┘
```

### Example: Login Request

**Step 1: UI triggers request**
```dart
// User taps login button
ElevatedButton(
  onPressed: () {
    context.read<AuthCubit>().login(email, password);
  },
)
```

**Step 2: Cubit calls UseCase**
```dart
Future<void> login(String email, String password) async {
  emit(AuthLoading());
  final result = await _loginUseCase(email, password);
  // ...
}
```

**Step 3: UseCase calls Repository**
```dart
Future<Either<String, User>> call(String email, String password) async {
  return await _repository.login(email, password);
}
```

**Step 4: Repository calls Service**
```dart
Future<Either<String, User>> login(String email, String password) async {
  try {
    final response = await _authService.login(email: email, password: password);
    // ...
  }
}
```

**Step 5: Service makes HTTP request**
```dart
Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  final response = await dio.post('/auth/login', data: {...});
  return response.data;
}
```

**Step 6: Dio sends request**
```http
POST https://api.bitego.com/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "Password123!"
}
```

**Step 7: Backend responds**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "user": {
    "id": "123",
    "email": "user@example.com",
    "full_name": "John Doe"
  },
  "tokens": {
    "access_token": "eyJhbGci...",
    "refresh_token": "eyJhbGci...",
    "expires_in": 3600
  }
}
```

**Step 8: Response flows back**
```dart
// Service returns data
// Repository converts to Entity
// UseCase returns Either<Error, User>
// Cubit emits AuthAuthenticated state
// UI rebuilds with new state
```

---

## Configuration

### Base URL Configuration

**Location**: [lib/core/config/flavor_config.dart](../lib/core/config/flavor_config.dart)

```dart
class FlavorConfig {
  final String name;
  final String apiBaseUrl;
  final bool enableLogging;

  FlavorConfig({
    required this.name,
    required this.apiBaseUrl,
    required this.enableLogging,
  });

  static FlavorConfig _current = FlavorConfig(
    name: 'dev',
    apiBaseUrl: 'https://dev-api.bitego.com',
    enableLogging: true,
  );

  static FlavorConfig get current => _current;

  static void setDev() {
    _current = FlavorConfig(
      name: 'dev',
      apiBaseUrl: 'https://dev-api.bitego.com',
      enableLogging: true,
    );
  }

  static void setProd() {
    _current = FlavorConfig(
      name: 'prod',
      apiBaseUrl: 'https://api.bitego.com',
      enableLogging: false,
    );
  }
}
```

### Timeout Configuration

**Location**: [lib/core/config/timing_config.dart](../lib/core/config/timing_config.dart)

```dart
class TimingConfig {
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
```

---

## Best Practices

### 1. Always Use Service Base Classes

```dart
// ✅ GOOD
class AuthService extends PublicApiService {
  AuthService(super.dio);
}

// ❌ BAD
class AuthService {
  final Dio dio;
  AuthService(this.dio);
}
```

### 2. Handle Errors in Repository

```dart
// ✅ GOOD
@override
Future<Either<String, User>> login(...) async {
  try {
    final response = await _service.login(...);
    return Right(response.toEntity());
  } on DioException catch (e) {
    return Left(ApiErrorHandler.handle(e));
  }
}

// ❌ BAD (let errors bubble up)
@override
Future<User> login(...) async {
  final response = await _service.login(...);
  return response.toEntity();
  // Error crashes app!
}
```

### 3. Use Constants for Endpoints

```dart
// ✅ GOOD
await dio.post(ApiEndpoints.login, ...);

// ❌ BAD (magic strings)
await dio.post('/auth/login', ...);
```

### 4. Log All Requests in Dev

```dart
if (FlavorConfig.current.enableLogging) {
  dio.interceptors.add(LogInterceptor(...));
}
```

### 5. Never Log in Production

```dart
// ✅ GOOD
static void setProd() {
  _current = FlavorConfig(
    name: 'prod',
    apiBaseUrl: 'https://api.bitego.com',
    enableLogging: false, // Disabled in prod
  );
}
```

---

## Summary

### Key Components

| Component | Responsibility |
|-----------|---------------|
| **DioClient** | Creates public/protected Dio instances |
| **PublicApiService** | Base for unauthenticated services |
| **BaseApiService** | Base for authenticated services |
| **AuthInterceptor** | Injects Bearer tokens, handles 401 |
| **ApiErrorHandler** | Maps errors to user-friendly messages |

### Client Types

| Client | Auth | Used By |
|--------|------|---------|
| **Public** | ❌ No | register, login, forgotPassword |
| **Protected** | ✅ Yes | profile, cart, orders |

### Error Handling Flow

```
DioException → ApiErrorHandler → User-friendly message → UI
```

### Request Flow

```
Cubit → UseCase → Repository → Service → Dio → Backend
```

---

**Documentation Complete!** You now have comprehensive docs covering:
1. [Project Overview](README.md)
2. [Clean Architecture](CLEAN_ARCHITECTURE.md)
3. [State Management](STATE_MANAGEMENT.md)
4. [SOLID Principles](SOLID_PRINCIPLES.md)
5. [Authentication](AUTHENTICATION.md)
6. [Onboarding & Splash](ONBOARDING_SPLASH.md)
7. [API & Networking](API_NETWORKING.md)
