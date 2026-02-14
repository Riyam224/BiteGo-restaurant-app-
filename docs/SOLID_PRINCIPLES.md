# SOLID Principles in BiteGo

> How SOLID principles are applied throughout the Restaurant App codebase

## Table of Contents

- [What are SOLID Principles?](#what-are-solid-principles)
- [S - Single Responsibility Principle](#s---single-responsibility-principle)
- [O - Open/Closed Principle](#o---openclosed-principle)
- [L - Liskov Substitution Principle](#l---liskov-substitution-principle)
- [I - Interface Segregation Principle](#i---interface-segregation-principle)
- [D - Dependency Inversion Principle](#d---dependency-inversion-principle)
- [Real Examples from BiteGo](#real-examples-from-bitego)

## What are SOLID Principles?

SOLID is an acronym for five design principles that make software more maintainable, flexible, and scalable:

| Letter | Principle | Focus |
|--------|-----------|-------|
| **S** | Single Responsibility | One class = one reason to change |
| **O** | Open/Closed | Open for extension, closed for modification |
| **L** | Liskov Substitution | Subtypes must be substitutable for base types |
| **I** | Interface Segregation | Many specific interfaces > one general interface |
| **D** | Dependency Inversion | Depend on abstractions, not concretions |

---

## S - Single Responsibility Principle

> A class should have one, and only one, reason to change.

### What it means

Each class should do **one thing** and do it well. If a class has multiple responsibilities, changes to one responsibility can affect others.

### Examples in BiteGo

#### ✅ GOOD: Separated Responsibilities

```dart
// ❌ BAD: Multiple responsibilities in one class
class UserManager {
  // Responsibility 1: User authentication
  Future<User> login(String email, String password) async {
    final response = await http.post('/login', ...);
    return User.fromJson(response.data);
  }

  // Responsibility 2: User profile management
  Future<User> updateProfile(String name) async {
    final response = await http.put('/profile', ...);
    return User.fromJson(response.data);
  }

  // Responsibility 3: Token storage
  Future<void> saveToken(String token) async {
    await SharedPreferences.getInstance().then((prefs) =>
      prefs.setString('token', token)
    );
  }

  // TOO MANY RESPONSIBILITIES!
}

// ✅ GOOD: Separate classes for separate concerns
class AuthService extends PublicApiService {
  // ONLY handles authentication API calls
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post('/auth/login', data: {...});
    return response.data;
  }
}

class ProfileService extends BaseApiService {
  // ONLY handles profile API calls
  Future<Map<String, dynamic>> updateProfile(String name) async {
    final response = await dio.put('/profile', data: {...});
    return response.data;
  }
}

class AppPrefs {
  // ONLY handles local storage
  Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, token);
  }
}
```

**Why better?**
- `AuthService` changes only when auth API changes
- `ProfileService` changes only when profile API changes
- `AppPrefs` changes only when storage mechanism changes
- Each class has **one reason to change**

---

#### Real Example: UseCases

Each UseCase has a **single responsibility**:

```dart
// lib/features/auth/domain/usecases/login_usecase.dart
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  // ONLY responsible for login logic
  Future<Either<String, User>> call(
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      return const Left('Email and password are required');
    }

    return await _repository.login(email, password);
  }
}

// lib/features/auth/domain/usecases/register_usecase.dart
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  // ONLY responsible for registration logic
  Future<Either<String, User>> call({
    required String email,
    required String password,
    required String fullName,
  }) async {
    // Validation and delegation
    return await _repository.register(...);
  }
}

// lib/features/auth/domain/usecases/logout_usecase.dart
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  // ONLY responsible for logout logic
  Future<Either<String, void>> call() async {
    return await _repository.logout();
  }
}
```

**Benefits**:
- Easy to test (each UseCase can be tested independently)
- Easy to modify (changing login doesn't affect registration)
- Easy to understand (one class = one operation)

---

#### Real Example: Dual API Client Architecture

```dart
// lib/core/networking/dio_client.dart

// Separate clients for different responsibilities
class DioClient {
  // Factory for PUBLIC endpoints (no auth)
  static Dio createPublicDio() {
    final dio = Dio(BaseOptions(
      baseUrl: FlavorConfig.current.apiBaseUrl,
      connectTimeout: TimingConfig.connectTimeout,
      receiveTimeout: TimingConfig.receiveTimeout,
    ));

    // Add logging interceptor (NO auth interceptor)
    if (FlavorConfig.current.enableLogging) {
      dio.interceptors.add(LogInterceptor(...));
    }

    return dio;
  }

  // Factory for PROTECTED endpoints (with auth)
  static Dio createProtectedDio() {
    final dio = Dio(BaseOptions(
      baseUrl: FlavorConfig.current.apiBaseUrl,
      connectTimeout: TimingConfig.connectTimeout,
      receiveTimeout: TimingConfig.receiveTimeout,
    ));

    // Add auth interceptor + logging
    dio.interceptors.add(AuthInterceptor());

    if (FlavorConfig.current.enableLogging) {
      dio.interceptors.add(LogInterceptor(...));
    }

    return dio;
  }
}
```

**Responsibilities separated**:
- `createPublicDio()` - Handles unauthenticated requests
- `createProtectedDio()` - Handles authenticated requests
- Each method has **one responsibility**

---

## O - Open/Closed Principle

> Classes should be open for extension, but closed for modification.

### What it means

You should be able to **add new functionality** without changing existing code.

### Examples in BiteGo

#### ✅ GOOD: Extensible Architecture

```dart
// ❌ BAD: Must modify class to add new payment method
class PaymentProcessor {
  Future<void> processPayment(String type, double amount) async {
    if (type == 'credit_card') {
      // Process credit card
    } else if (type == 'paypal') {
      // Process PayPal
    } else if (type == 'apple_pay') {
      // Process Apple Pay (ADDED LATER - requires modifying this class!)
    }
  }
}

// ✅ GOOD: Can extend without modifying
abstract class PaymentMethod {
  Future<void> process(double amount);
}

class CreditCardPayment implements PaymentMethod {
  @override
  Future<void> process(double amount) async {
    // Credit card logic
  }
}

class PayPalPayment implements PaymentMethod {
  @override
  Future<void> process(double amount) async {
    // PayPal logic
  }
}

// Add new payment method WITHOUT modifying existing classes
class ApplePayPayment implements PaymentMethod {
  @override
  Future<void> process(double amount) async {
    // Apple Pay logic
  }
}

class PaymentProcessor {
  Future<void> processPayment(PaymentMethod method, double amount) async {
    await method.process(amount); // Polymorphism!
  }
}
```

---

#### Real Example: Base API Service

```dart
// lib/core/networking/public_api_service.dart
abstract class PublicApiService {
  final Dio dio;

  PublicApiService(this.dio);

  // Common functionality for all public services
  Future<T> handleResponse<T>(Future<Response> Function() request) async {
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}

// EXTEND without modifying base class
class AuthService extends PublicApiService {
  AuthService(super.dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    return handleResponse(() => dio.post('/auth/login', ...));
  }

  Future<Map<String, dynamic>> register(...) async {
    return handleResponse(() => dio.post('/auth/register', ...));
  }
}

// Add new service WITHOUT modifying PublicApiService
class NotificationService extends PublicApiService {
  NotificationService(super.dio);

  Future<List<dynamic>> getNotifications() async {
    return handleResponse(() => dio.get('/notifications'));
  }
}
```

**Benefits**:
- `PublicApiService` never needs modification
- New services just extend the base class
- **Open for extension, closed for modification**

---

#### Real Example: State Extensions

```dart
// lib/features/auth/presentation/cubit/auth_state.dart
@immutable
abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
  @override
  List<Object> get props => [];
}

// EXTEND by adding new states
class AuthLoading extends AuthState {
  const AuthLoading();
  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
  @override
  List<Object> get props => [user];
}

// Add new state later WITHOUT modifying existing states
class AuthBiometricSuccess extends AuthState {
  final User user;
  const AuthBiometricSuccess(this.user);
  @override
  List<Object> get props => [user];
}
```

---

## L - Liskov Substitution Principle

> Objects of a superclass should be replaceable with objects of a subclass without breaking the application.

### What it means

If class `B` extends class `A`, you should be able to use `B` anywhere you use `A` without issues.

### Examples in BiteGo

#### ✅ GOOD: Proper Substitution

```dart
// ❌ BAD: Violates LSP
class Bird {
  void fly() {
    print('Flying...');
  }
}

class Penguin extends Bird {
  @override
  void fly() {
    throw Exception('Penguins cannot fly!'); // BREAKS LSP!
  }
}

void makeBirdFly(Bird bird) {
  bird.fly(); // Will crash if bird is Penguin!
}

// ✅ GOOD: Respects LSP
abstract class Bird {
  void eat();
}

abstract class FlyingBird extends Bird {
  void fly();
}

class Eagle extends FlyingBird {
  @override
  void fly() => print('Eagle flying');

  @override
  void eat() => print('Eagle eating');
}

class Penguin extends Bird {
  @override
  void eat() => print('Penguin eating');
  // No fly method - Penguin doesn't promise to fly
}
```

---

#### Real Example: API Services

```dart
// lib/core/networking/public_api_service.dart
abstract class PublicApiService {
  final Dio dio;

  PublicApiService(this.dio);
}

// All subclasses can be used interchangeably
class AuthService extends PublicApiService {
  AuthService(super.dio);

  Future<Map<String, dynamic>> login(...) async {
    return await dio.post('/auth/login', ...);
  }
}

class NotificationService extends PublicApiService {
  NotificationService(super.dio);

  Future<List<dynamic>> getNotifications() async {
    return await dio.get('/notifications');
  }
}

// Function accepts ANY PublicApiService
void configureService(PublicApiService service) {
  // Can use AuthService or NotificationService here
  print('Service configured with base URL: ${service.dio.options.baseUrl}');
}

// LSP respected - all subclasses work the same way
configureService(AuthService(dio));           // ✅ Works
configureService(NotificationService(dio));   // ✅ Works
```

---

#### Real Example: Repository Pattern

```dart
// Domain interface
abstract class AuthRepository {
  Future<Either<String, User>> login(String email, String password);
  Future<Either<String, User>> register(...);
  Future<Either<String, void>> logout();
}

// Data implementation
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<String, User>> login(String email, String password) async {
    // Implementation
  }

  @override
  Future<Either<String, User>> register(...) async {
    // Implementation
  }

  @override
  Future<Either<String, void>> logout() async {
    // Implementation
  }
}

// Mock for testing
class MockAuthRepository implements AuthRepository {
  @override
  Future<Either<String, User>> login(String email, String password) async {
    return Right(User(id: '1', email: email, fullName: 'Test User'));
  }

  @override
  Future<Either<String, User>> register(...) async {
    return Right(User(id: '2', email: 'mock@test.com', fullName: 'Mock'));
  }

  @override
  Future<Either<String, void>> logout() async {
    return const Right(null);
  }
}

// UseCase works with ANY AuthRepository implementation
class LoginUseCase {
  final AuthRepository _repository; // Can be Impl or Mock

  LoginUseCase(this._repository);

  Future<Either<String, User>> call(String email, String password) async {
    return await _repository.login(email, password);
    // Works with AuthRepositoryImpl AND MockAuthRepository!
  }
}
```

**Benefits**:
- Production uses `AuthRepositoryImpl`
- Tests use `MockAuthRepository`
- `LoginUseCase` works with both (LSP respected)

---

## I - Interface Segregation Principle

> Clients should not be forced to depend on interfaces they don't use.

### What it means

Better to have **many small, specific interfaces** than one large, general interface.

### Examples in BiteGo

#### ✅ GOOD: Segregated Interfaces

```dart
// ❌ BAD: Fat interface
abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password);
  Future<void> logout();
  Future<User> getProfile();
  Future<User> updateProfile(String name);
  Future<void> deleteAccount();
  Future<List<Order>> getOrders();
  Future<void> addToCart(String productId);
  Future<Cart> getCart();
  // Too many responsibilities in one interface!
}

// LoginUseCase only needs login, but depends on entire interface
class LoginUseCase {
  final UserRepository _repository;

  LoginUseCase(this._repository); // Must implement ALL methods!
}

// ✅ GOOD: Segregated interfaces
abstract class AuthRepository {
  Future<Either<String, User>> login(String email, String password);
  Future<Either<String, User>> register(...);
  Future<Either<String, void>> logout();
}

abstract class ProfileRepository {
  Future<Either<String, User>> getProfile();
  Future<Either<String, User>> updateProfile(String name);
  Future<Either<String, void>> deleteAccount();
}

abstract class OrderRepository {
  Future<Either<String, List<Order>>> getOrders();
  Future<Either<String, Order>> createOrder(...);
}

abstract class CartRepository {
  Future<Either<String, void>> addToCart(String productId);
  Future<Either<String, Cart>> getCart();
}

// Now LoginUseCase only depends on what it needs
class LoginUseCase {
  final AuthRepository _repository; // Only auth methods!

  LoginUseCase(this._repository);
}

class GetProfileUseCase {
  final ProfileRepository _repository; // Only profile methods!

  GetProfileUseCase(this._repository);
}
```

**Benefits**:
- Classes depend only on what they need
- Easier to test (smaller mocks)
- Changes to cart don't affect authentication

---

#### Real Example: Validation Interfaces

```dart
// lib/core/validation/validation.dart

// Separate validators instead of one giant validator
abstract class EmailInput {
  static bool isValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }
}

abstract class PasswordInput {
  static bool isValid(String password) {
    return password.length >= 8;
  }
}

abstract class FullNameInput {
  static bool isValid(String fullName) {
    return fullName.trim().split(' ').length >= 2;
  }
}

// Use only what you need
class LoginForm extends StatelessWidget {
  void validate(String email, String password) {
    if (!EmailInput.isValid(email)) {
      // Show error
    }
    if (!PasswordInput.isValid(password)) {
      // Show error
    }
    // Doesn't need FullNameInput!
  }
}

class RegisterForm extends StatelessWidget {
  void validate(String email, String password, String fullName) {
    if (!EmailInput.isValid(email)) {
      // Show error
    }
    if (!PasswordInput.isValid(password)) {
      // Show error
    }
    if (!FullNameInput.isValid(fullName)) {
      // Show error
    }
  }
}
```

---

## D - Dependency Inversion Principle

> High-level modules should not depend on low-level modules. Both should depend on abstractions.

### What it means

- **High-level**: Business logic (UseCases, Cubits)
- **Low-level**: Implementation details (API services, databases)
- **Abstraction**: Interfaces/abstract classes

**Depend on interfaces, not concrete implementations.**

### Examples in BiteGo

#### ✅ GOOD: Depending on Abstractions

```dart
// ❌ BAD: High-level depends on low-level
class LoginUseCase {
  final AuthService _authService; // Concrete implementation!

  LoginUseCase(this._authService);

  Future<User> call(String email, String password) async {
    // Directly using AuthService (low-level)
    final response = await _authService.login(email, password);
    return UserModel.fromJson(response).toEntity();
  }
}
```

**Problems**:
- `LoginUseCase` (high-level) depends on `AuthService` (low-level)
- Cannot swap implementations
- Hard to test (must use real AuthService)

```dart
// ✅ GOOD: Both depend on abstraction
// ABSTRACTION (Domain layer)
abstract class AuthRepository {
  Future<Either<String, User>> login(String email, String password);
}

// HIGH-LEVEL (Domain layer)
class LoginUseCase {
  final AuthRepository _repository; // Abstraction!

  LoginUseCase(this._repository);

  Future<Either<String, User>> call(String email, String password) async {
    return await _repository.login(email, password);
  }
}

// LOW-LEVEL (Data layer)
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<Either<String, User>> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      return Right(UserModel.fromJson(response).toEntity());
    } catch (e) {
      return Left('Login failed');
    }
  }
}
```

**Benefits**:
- `LoginUseCase` depends on `AuthRepository` (abstraction)
- `AuthRepositoryImpl` implements `AuthRepository` (abstraction)
- Both depend on the interface, not each other
- Easy to swap implementations (production, mock, fake)

---

#### Dependency Flow

```
┌─────────────────────────────────┐
│   Presentation Layer (Cubit)   │
│                                 │
│   - Depends on UseCases         │
└────────────┬────────────────────┘
             │ Uses ↓
┌────────────▼────────────────────┐
│   Domain Layer (UseCase)        │
│                                 │
│   - Depends on Repository       │
│     INTERFACE (abstraction)     │
└────────────┬────────────────────┘
             │ ↑ Implements
┌────────────▼────────────────────┐
│   Data Layer (Repository Impl)  │
│                                 │
│   - Implements Repository       │
│   - Uses Service (low-level)    │
└─────────────────────────────────┘
```

---

#### Real Example: AuthCubit

```dart
// lib/features/auth/presentation/cubit/auth_cubit.dart
class AuthCubit extends Cubit<AuthState> {
  // Depends on abstractions (UseCases), NOT implementations
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    // Calls UseCase (abstraction), doesn't know about services/repositories
    final result = await _loginUseCase(email, password);

    result.fold(
      (error) => emit(AuthError(error)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
```

**Cubit doesn't know**:
- How data is fetched (HTTP, database, cache)
- How errors are handled
- How tokens are stored
- **It only knows about business logic (UseCases)**

---

#### Real Example: Testing with DIP

```dart
// Production (uses real implementations)
final authRepository = AuthRepositoryImpl(
  authService: AuthService(dio),
  prefs: AppPrefs(),
);

final loginUseCase = LoginUseCase(authRepository);

final cubit = AuthCubit(
  loginUseCase: loginUseCase,
  // ...
);

// Testing (uses mocks)
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('login emits AuthAuthenticated on success', () async {
    // Create mock
    final mockRepository = MockAuthRepository();

    // Configure mock behavior
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => Right(User(...)));

    // Create UseCase with mock
    final loginUseCase = LoginUseCase(mockRepository);

    // Create Cubit with UseCase
    final cubit = AuthCubit(loginUseCase: loginUseCase);

    // Test
    await cubit.login('test@example.com', 'password');

    expect(cubit.state, isA<AuthAuthenticated>());
  });
}
```

**Because of DIP**:
- Production uses `AuthRepositoryImpl`
- Tests use `MockAuthRepository`
- `LoginUseCase` and `AuthCubit` work with both!

---

## Real Examples from BiteGo

### Example 1: Authentication Flow (All SOLID Principles)

```dart
// ===== S: Single Responsibility =====
// Each class has ONE job

// AuthService: ONLY makes HTTP requests
class AuthService extends PublicApiService {
  Future<Map<String, dynamic>> login(...) async { }
}

// LoginUseCase: ONLY handles login business logic
class LoginUseCase {
  Future<Either<String, User>> call(...) async { }
}

// AuthCubit: ONLY manages authentication state
class AuthCubit extends Cubit<AuthState> {
  Future<void> login(...) async { }
}

// ===== O: Open/Closed =====
// Can add new auth methods without modifying existing code

abstract class AuthRepository {
  Future<Either<String, User>> login(...);
}

// Add Google sign-in WITHOUT modifying AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<String, User>> login(...) async { }

  // New method (extends functionality)
  Future<Either<String, User>> googleSignIn(String idToken) async { }
}

// ===== L: Liskov Substitution =====
// Any AuthRepository implementation works

class LoginUseCase {
  final AuthRepository _repository; // Interface

  LoginUseCase(this._repository);
}

// Production
LoginUseCase(AuthRepositoryImpl(...)); // ✅ Works

// Testing
LoginUseCase(MockAuthRepository());    // ✅ Works

// ===== I: Interface Segregation =====
// Separate repositories for separate concerns

abstract class AuthRepository {
  Future<Either<String, User>> login(...);
  Future<Either<String, User>> register(...);
}

abstract class ProfileRepository {
  Future<Either<String, User>> getProfile();
  Future<Either<String, User>> updateProfile(...);
}

// LoginUseCase only depends on AuthRepository
class LoginUseCase {
  final AuthRepository _repository; // Not ProfileRepository!
}

// ===== D: Dependency Inversion =====
// Depend on abstractions

class LoginUseCase {
  final AuthRepository _repository; // Interface (abstraction)

  LoginUseCase(this._repository);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service; // Concrete, but injected

  AuthRepositoryImpl(this._service);
}
```

---

### Example 2: API Client Architecture (S, O, D)

```dart
// ===== S: Single Responsibility =====

// DioClient: ONLY creates Dio instances
class DioClient {
  static Dio createPublicDio() { }
  static Dio createProtectedDio() { }
}

// PublicApiService: ONLY provides base for public endpoints
abstract class PublicApiService {
  final Dio dio;
  PublicApiService(this.dio);
}

// AuthService: ONLY handles auth API calls
class AuthService extends PublicApiService {
  Future<Map<String, dynamic>> login(...) { }
}

// ===== O: Open/Closed =====

// Add new service WITHOUT modifying PublicApiService
class NotificationService extends PublicApiService {
  Future<List> getNotifications() { }
}

// ===== D: Dependency Inversion =====

// AuthService depends on Dio (abstraction/interface)
class AuthService extends PublicApiService {
  AuthService(super.dio); // Injected, not created
}

// Can inject different Dio instances
AuthService(DioClient.createPublicDio());
AuthService(mockDio); // For testing
```

---

## Summary

### SOLID Benefits in BiteGo

| Principle | Benefit | Example in BiteGo |
|-----------|---------|-------------------|
| **Single Responsibility** | Easy to maintain | Each UseCase = one operation |
| **Open/Closed** | Easy to extend | Add new services without modifying base classes |
| **Liskov Substitution** | Easy to test | Swap real repositories with mocks |
| **Interface Segregation** | Focused dependencies | Auth, Profile, Cart repos separated |
| **Dependency Inversion** | Flexible architecture | Depend on interfaces, not implementations |

### Quick Reference

**When designing a new feature, ask**:

1. **S**: Does this class have ONE reason to change?
2. **O**: Can I add functionality without modifying existing code?
3. **L**: Can I swap implementations without breaking things?
4. **I**: Do my interfaces have only what's needed?
5. **D**: Am I depending on abstractions or concrete classes?

If you answer "yes" to all, you're writing SOLID code!

---

**Next**: See [CLEAN_ARCHITECTURE.md](CLEAN_ARCHITECTURE.md) to understand how SOLID principles integrate with Clean Architecture layers.
