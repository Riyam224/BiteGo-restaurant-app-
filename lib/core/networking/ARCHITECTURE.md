# 🏛️ API Architecture Documentation

## 📚 Table of Contents
1. [Clean Architecture Overview](#clean-architecture-overview)
2. [SOLID Principles Applied](#solid-principles-applied)
3. [Project Structure](#project-structure)
4. [How to Use](#how-to-use)
5. [Creating New Services](#creating-new-services)
6. [Authentication Flow](#authentication-flow)

---

## 🎯 Clean Architecture Overview

### What is Clean Architecture?

Think of your app as a **3-layer cake**:

```
┌─────────────────────────────────────┐
│   PRESENTATION LAYER (UI)           │  ← What users see
│   - Screens, Widgets, State Mgmt    │
├─────────────────────────────────────┤
│   DOMAIN LAYER (Business Logic)     │  ← Business rules
│   - Use Cases, Entities, Repos      │
├─────────────────────────────────────┤
│   DATA LAYER (API/Database)         │  ← Where data comes from
│   - Services, Models, Data Sources  │
└─────────────────────────────────────┘
```

### Why This Matters

- **Separation of Concerns**: Each layer has ONE job
- **Testability**: Easy to test each layer independently
- **Maintainability**: Changes in one layer don't break others
- **Scalability**: Easy to add new features without breaking existing code

---

## ⚙️ SOLID Principles Applied

### 1. **S** - Single Responsibility Principle
> Each class has ONE job and does it well

**Example:**
- `DioClient` → Only creates and configures HTTP clients (public & protected)
- `AuthService` → Only handles public authentication API calls
- `ProfileService` → Only handles protected profile API calls
- `ProductService` → Only handles product API calls
- `AppPrefs` → Only handles local storage

### 2. **O** - Open/Closed Principle
> Open for extension, closed for modification

**Example:**
- `BaseApiService` is a base class that you **extend** (don't modify)
- Want a new feature? Create a new service that extends `BaseApiService`
- No need to touch existing code!

### 3. **L** - Liskov Substitution Principle
> Child classes can replace parent classes without breaking the system

**Example:**
- `AuthService` extends `BaseApiService`
- Anywhere you expect `BaseApiService`, you can use `AuthService`

### 4. **I** - Interface Segregation Principle
> Don't force classes to depend on methods they don't use

**Example:**
- `AuthService` only exposes auth methods (login, register, etc.)
- `ProductService` only exposes product methods (getProducts, etc.)
- Each service is focused and lean

### 5. **D** - Dependency Inversion Principle
> Depend on abstractions, not concrete implementations

**Example:**
- Services depend on `Dio` interface, not a specific HTTP library
- Easy to swap out Dio for another HTTP library if needed

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── networking/
│   │   ├── public_api_service.dart    ← Base class for PUBLIC endpoints (no auth)
│   │   ├── base_api_service.dart      ← Base class for PROTECTED endpoints (with auth)
│   │   ├── dio_client.dart            ← HTTP client factory (public & protected)
│   │   ├── api_error_handler.dart     ← Error handling
│   │   └── endpoints.dart             ← All API endpoints
│   ├── storage/
│   │   └── shared_prefs.dart          ← Token storage
│   └── constants/
│       └── api_base.dart              ← Base URL config
│
└── features/
    ├── auth/
    │   └── data/
    │       └── services/
    │           ├── auth_service.dart     ← PUBLIC Auth API calls (extends PublicApiService)
    │           └── profile_service.dart  ← PROTECTED Profile API calls (extends BaseApiService)
    └── home/
        └── data/
            └── services/
                └── product_service.dart  ← Product API calls
```

## 🔐 Public vs Protected APIs

**IMPORTANT:** The architecture separates public and protected endpoints to prevent authentication issues.

### Public APIs (NO Authentication Required)
- Use `PublicApiService` as base class
- **NO** Authorization headers are sent
- Examples: register, login, forgot-password, verify-otp, reset-password

```dart
class AuthService extends PublicApiService {
  Future<Response> register({...}) async {
    return await post(ApiEndpoints.register, data: {...});
  }
}
```

### Protected APIs (Authentication Required)
- Use `BaseApiService` as base class
- **Automatically** adds Authorization: Bearer <token> headers
- Examples: profile, cart, orders, addresses, reviews

```dart
class ProfileService extends BaseApiService {
  Future<Response> getProfile() async {
    return await get(ApiEndpoints.profile);
  }
}
```

### Why This Separation Matters
❌ **Without separation:** Registration fails when an expired token exists in storage
✅ **With separation:** Public endpoints never send tokens, protected endpoints always do

---

## 🚀 How to Use

### 1. **Authentication Flow (Login Example)**

```dart
import 'package:restaurant_app/features/auth/data/services/auth_service.dart';
import 'package:restaurant_app/core/storage/shared_prefs.dart';

// 1. Create service instance
final authService = AuthService();

// 2. Call login API
try {
  final response = await authService.login(
    email: 'user@example.com',
    password: 'password123',
  );

  // 3. Extract tokens from response
  final accessToken = response.data['access'];
  final refreshToken = response.data['refresh'];

  // 4. Save tokens to secure storage
  await AppPrefs.setTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );

  // 5. Navigate to home screen
  // ... navigation code

} catch (error) {
  // 6. Handle error (error is already a user-friendly string)
  print('Login failed: $error');
  // Show error to user in UI
}
```

### 2. **Fetching Products**

```dart
import 'package:restaurant_app/features/home/data/services/product_service.dart';

// 1. Create service instance
final productService = ProductService();

// 2. Fetch products with filters
try {
  final response = await productService.getProducts(
    page: 1,
    search: 'pizza',
    categoryId: 5,
    minPrice: 10.0,
    maxPrice: 50.0,
    sortBy: 'price',
  );

  // 3. Parse response data
  final products = response.data['results']; // List of products

  // 4. Update UI with products
  // ... UI update code

} catch (error) {
  print('Failed to fetch products: $error');
}
```

### 3. **Accessing Authenticated Endpoints**

All authenticated endpoints **automatically** include the JWT token!

```dart
// Create a service that extends BaseApiService (protected)
final profileService = ProfileService();

// No need to manually add token - it's auto-injected!
final response = await profileService.getProfile();
// DioClient automatically adds: Authorization: Bearer <token>
```

### 4. **Handling Token Refresh**

```dart
try {
  // If access token expires, refresh it
  final refreshToken = await AppPrefs.getRefreshToken();

  final response = await authService.refreshToken(
    refreshToken: refreshToken!,
  );

  final newAccessToken = response.data['access'];

  // Save new access token
  await AppPrefs.setAccessToken(newAccessToken);

} catch (error) {
  // Refresh failed - logout user
  await AppPrefs.clearTokens();
  // Navigate to login screen
}
```

### 5. **Logout**

```dart
// Clear tokens from storage
await AppPrefs.clearTokens();

// Navigate to welcome/login screen
// ... navigation code
```

---

## ✨ Creating New Services

Creating a new service is **EASY** - just 3 steps!

### Step 1: Choose the Right Base Class

**For PUBLIC endpoints** (no authentication):
```dart
// lib/features/auth/data/services/auth_service.dart
import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/public_api_service.dart';
import 'package:restaurant_app/core/networking/endpoints.dart';

class AuthService extends PublicApiService {
  // Your methods here
}
```

**For PROTECTED endpoints** (requires authentication):
```dart
// lib/features/cart/data/services/cart_service.dart
import 'package:dio/dio.dart';
import 'package:restaurant_app/core/networking/base_api_service.dart';
import 'package:restaurant_app/core/networking/endpoints.dart';

class CartService extends BaseApiService {
  // Your methods here
}
```

### Step 2: Add Methods

```dart
class CartService extends BaseApiService {
  /// Get user's cart
  Future<Response> getCart() async {
    return await get(ApiEndpoints.cart);
  }

  /// Add item to cart
  Future<Response> addToCart({
    required int productId,
    required int quantity,
  }) async {
    return await post(
      ApiEndpoints.addToCart,
      data: {
        'product_id': productId,
        'quantity': quantity,
      },
    );
  }

  /// Remove item from cart
  Future<Response> removeCartItem(int itemId) async {
    return await delete(ApiEndpoints.removeCartItem(itemId));
  }
}
```

### Step 3: Use It!

```dart
final cartService = CartService();

// Get cart
final response = await cartService.getCart();
final cartItems = response.data['items'];

// Add to cart
await cartService.addToCart(productId: 42, quantity: 2);

// Remove from cart
await cartService.removeCartItem(15);
```

**That's it!** No need to write HTTP logic - it's all inherited from `BaseApiService`!

---

## 🔐 Authentication Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    USER OPENS APP                        │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
          ┌──────────────────────┐
          │ Check if authenticated│
          │  AppPrefs.getAccessToken()  │
          └──────────┬───────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
   Has Token?                No Token
        │                         │
        │                         ▼
        │              ┌────────────────┐
        │              │ Show Login UI   │
        │              └────────┬───────┘
        │                       │
        │                       ▼
        │              ┌────────────────────┐
        │              │ User Enters         │
        │              │ Email & Password    │
        │              └────────┬───────────┘
        │                       │
        │                       ▼
        │              ┌────────────────────┐
        │              │ authService.login() │
        │              └────────┬───────────┘
        │                       │
        │              ┌────────┴────────┐
        │              │                 │
        │              ▼                 ▼
        │          Success            Error
        │              │                 │
        │              ▼                 ▼
        │     ┌───────────────┐    Show Error
        │     │ Save Tokens   │         │
        │     │ AppPrefs.setTokens() │
        │     └───────┬───────┘         │
        │             │                 │
        └─────────────┴─────────────────┘
                      │
                      ▼
          ┌─────────────────────┐
          │ Navigate to Home     │
          └─────────────────────┘
                      │
                      ▼
          ┌─────────────────────────────┐
          │ All API calls now include:   │
          │ Authorization: Bearer <token>│
          └─────────────────────────────┘
```

---

## 🎯 Key Takeaways

### ✅ **What We Built:**

1. **Token Storage System** - Securely stores JWT tokens
2. **Auto-Authentication** - Automatically adds tokens to requests
3. **Base Service** - Reusable HTTP methods (GET, POST, etc.)
4. **Feature Services** - Easy-to-create, focused services
5. **Error Handling** - User-friendly error messages
6. **Clean Architecture** - Separation of concerns
7. **SOLID Principles** - Maintainable, scalable code

### 📝 **Remember:**

- **Don't modify** `BaseApiService` - extend it!
- **Don't hardcode** URLs - use `ApiEndpoints`
- **Don't manually add** tokens - `DioClient` does it automatically
- **Do create** new services for new features
- **Do follow** the existing patterns

### 🚀 **Next Steps:**

1. Create more services (OrderService, ReviewService, etc.)
2. Add state management (Provider, Riverpod, Bloc)
3. Create repositories (domain layer) between services and UI
4. Add unit tests for services
5. Implement token refresh interceptor

---

## 📚 Additional Resources

- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://www.digitalocean.com/community/conceptual_articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design)
- [Flutter + Dio Documentation](https://pub.dev/packages/dio)

---

**Happy Coding! 🎉**
