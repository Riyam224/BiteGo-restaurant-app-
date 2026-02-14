# Clean Architecture in BiteGo

> A comprehensive guide to understanding Clean Architecture implementation in the Restaurant App

## Table of Contents

- [What is Clean Architecture?](#what-is-clean-architecture)
- [The Three Layers](#the-three-layers)
- [Dependency Rule](#dependency-rule)
- [Data Flow](#data-flow)
- [Real Example: Authentication Feature](#real-example-authentication-feature)
- [Best Practices](#best-practices)

## What is Clean Architecture?

Clean Architecture is a software design philosophy that separates code into distinct layers, each with a specific responsibility. This separation provides:

- **Testability** - Each layer can be tested independently
- **Maintainability** - Changes in one layer don't ripple through the entire codebase
- **Scalability** - New features follow established patterns
- **Technology Independence** - Business logic is isolated from frameworks and UI

### Key Principles

1. **Independence of Frameworks** - Business logic doesn't depend on Flutter, Dio, or any framework
2. **Testable** - Business logic can be tested without UI, database, or external services
3. **UI Independence** - The UI can change without changing business logic
4. **Database Independence** - Can swap SharedPreferences for SQLite without breaking logic
5. **External Agency Independence** - Business logic knows nothing about the outside world

## The Three Layers

```
┌─────────────────────────────────────────────────┐
│           Presentation Layer                     │
│   (UI, Widgets, Cubits, States)                 │
│                                                  │
│   Dependencies: domain, flutter_bloc             │
└──────────────────┬──────────────────────────────┘
                   │ Uses ↓
┌──────────────────▼──────────────────────────────┐
│           Domain Layer                           │
│   (Entities, UseCases, Repository Interfaces)   │
│                                                  │
│   Dependencies: NONE (pure Dart)                 │
└──────────────────┬──────────────────────────────┘
                   │ ↑ Implements
┌──────────────────▼──────────────────────────────┐
│           Data Layer                             │
│   (Models, Repositories, Services, APIs)        │
│                                                  │
│   Dependencies: domain, dio, shared_preferences  │
└─────────────────────────────────────────────────┘
```

### 1. Presentation Layer

**Location**: `lib/features/[feature]/presentation/`

**Responsibilities**:
- Display UI to users
- Capture user input
- Manage UI state
- Delegate business logic to UseCases

**Components**:

#### Screens
Full-page widgets that represent app screens.

```dart
// lib/features/auth/presentation/screens/welcome_screen.dart
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(/* inject dependencies */),
      child: WelcomeScreenContent(),
    );
  }
}
```

#### Widgets
Reusable UI components used by screens.

```dart
// lib/features/auth/presentation/widgets/login_form.dart
class LoginForm extends StatelessWidget {
  // Displays email, password fields and login button
  // Calls cubit.login() on submit
}
```

#### Cubits
Manage presentation state and coordinate business logic.

```dart
// lib/features/auth/presentation/cubit/auth_cubit.dart
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthCubit(this._loginUseCase) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    // Call the domain layer UseCase
    final result = await _loginUseCase(email, password);

    result.fold(
      (error) => emit(AuthError(error)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
```

#### States
Immutable representations of UI state.

```dart
// lib/features/auth/presentation/cubit/auth_state.dart
@immutable
abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}
```

**Key Rules**:
- ✅ Can depend on Domain layer (UseCases, Entities, Repository interfaces)
- ✅ Can use Flutter packages (flutter_bloc, go_router, etc.)
- ❌ NEVER depends on Data layer (Services, Models)
- ❌ NEVER contains business logic (delegates to UseCases)

---

### 2. Domain Layer

**Location**: `lib/features/[feature]/domain/`

**Responsibilities**:
- Define business logic
- Define core business entities
- Define repository contracts (interfaces)
- Contain no framework-specific code

**Components**:

#### Entities
Pure business objects representing core concepts.

```dart
// lib/features/auth/domain/entities/user.dart
@immutable
class User extends Equatable {
  final String id;
  final String email;
  final String fullName;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
  });

  @override
  List<Object> get props => [id, email, fullName];
}
```

**Characteristics**:
- Immutable (`@immutable` annotation)
- Extend `Equatable` for value comparison
- No JSON serialization logic
- No external dependencies

#### UseCases
Single-responsibility business logic operations.

```dart
// lib/features/auth/domain/usecases/login_usecase.dart
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<String, User>> call(String email, String password) async {
    // Validation
    if (email.isEmpty || password.isEmpty) {
      return const Left('Email and password are required');
    }

    // Delegate to repository
    return await _repository.login(email, password);
  }
}
```

**Principles**:
- One UseCase = One business operation
- Named with verb pattern: `LoginUseCase`, `RegisterUseCase`, `GetUserProfileUseCase`
- Contains business validation
- Returns `Either<Error, Success>` for error handling

#### Repository Interfaces
Contracts that define data operations WITHOUT implementation.

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<String, User>> login(String email, String password);

  Future<Either<String, User>> register({
    required String email,
    required String password,
    required String fullName,
  });

  Future<Either<String, void>> logout();

  Future<Either<String, User>> googleSignIn(String idToken);
}
```

**Key Rules**:
- ✅ ZERO external dependencies (pure Dart only)
- ✅ Defines abstract contracts (interfaces)
- ✅ Contains business logic
- ❌ NEVER depends on Presentation or Data layers
- ❌ NEVER imports Flutter, Dio, SharedPreferences, etc.
- ❌ NEVER knows about JSON, HTTP, or databases

---

### 3. Data Layer

**Location**: `lib/features/[feature]/data/`

**Responsibilities**:
- Implement repository interfaces defined in Domain
- Communicate with external data sources (APIs, databases, storage)
- Transform external data into domain entities
- Handle network errors and exceptions

**Components**:

#### Models
Data Transfer Objects (DTOs) with JSON serialization.

```dart
// lib/features/auth/data/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String fullName;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
  });

  // JSON deserialization
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
    };
  }

  // Convert Model to Domain Entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
    );
  }
}
```

**Model vs Entity**:
| Aspect | Model (Data) | Entity (Domain) |
|--------|--------------|-----------------|
| Purpose | Data transport | Business logic |
| JSON | ✅ Has fromJson/toJson | ❌ No JSON |
| Dependencies | Can depend on domain | No dependencies |
| Layer | Data Layer | Domain Layer |
| Changes when | API changes | Business rules change |

#### Services
Handle API communication.

```dart
// lib/features/auth/data/services/auth_service.dart
class AuthService extends PublicApiService {
  AuthService(super.dio);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return response.data;
    } catch (e) {
      rethrow; // Let repository handle errors
    }
  }
}
```

**Service Types**:
- **PublicApiService** - For unauthenticated endpoints (login, register)
- **BaseApiService** - For authenticated endpoints (profile, cart)

#### Repository Implementations
Bridge between domain contracts and data sources.

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final AppPrefs _prefs;

  AuthRepositoryImpl(this._authService, this._prefs);

  @override
  Future<Either<String, User>> login(
    String email,
    String password,
  ) async {
    try {
      // Call the API service
      final response = await _authService.login(
        email: email,
        password: password,
      );

      // Parse the response
      final userModel = UserModel.fromJson(response['user']);
      final tokens = AuthTokensModel.fromJson(response['tokens']);

      // Save tokens to local storage
      await _prefs.setTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      // Convert Model to Entity and return success
      return Right(userModel.toEntity());

    } on DioException catch (e) {
      // Map network errors to user-friendly messages
      final errorMessage = ApiErrorHandler.handle(e);
      return Left(errorMessage);
    } catch (e) {
      return Left('An unexpected error occurred');
    }
  }
}
```

**Responsibilities**:
- ✅ Implements domain repository interface
- ✅ Calls appropriate service methods
- ✅ Transforms Models → Entities
- ✅ Handles errors and returns `Either<Error, Success>`
- ✅ Manages local storage (tokens, cache)

**Key Rules**:
- ✅ Can depend on Domain layer (implements interfaces)
- ✅ Can use external packages (Dio, SharedPreferences)
- ❌ NEVER depends on Presentation layer
- ❌ NEVER contains business logic (only data access logic)

---

## Dependency Rule

**The Golden Rule**: Dependencies point INWARD (toward Domain)

```
Presentation ──────▶ Domain ◀────── Data
     │                  │               │
     │                  │               │
     └──── USES ────────┘               │
                         └─ IMPLEMENTS ─┘
```

### What This Means

1. **Presentation depends on Domain**
   ```dart
   // ✅ GOOD: Presentation imports Domain
   import 'package:restaurant_app/features/auth/domain/entities/user.dart';
   import 'package:restaurant_app/features/auth/domain/usecases/login_usecase.dart';
   ```

2. **Data depends on Domain**
   ```dart
   // ✅ GOOD: Data implements Domain interfaces
   import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

   class AuthRepositoryImpl implements AuthRepository { }
   ```

3. **Domain depends on NOTHING**
   ```dart
   // ❌ BAD: Domain importing from Data or Presentation
   import 'package:restaurant_app/features/auth/data/models/user_model.dart'; // WRONG!
   import 'package:restaurant_app/features/auth/presentation/cubit/auth_cubit.dart'; // WRONG!

   // ✅ GOOD: Domain has no imports from other layers
   import 'package:equatable/equatable.dart'; // OK (external package)
   import 'package:dartz/dartz.dart'; // OK (external package)
   ```

4. **Presentation NEVER depends on Data**
   ```dart
   // ❌ BAD: Presentation importing from Data
   import 'package:restaurant_app/features/auth/data/services/auth_service.dart'; // WRONG!
   import 'package:restaurant_app/features/auth/data/models/user_model.dart'; // WRONG!

   // ✅ GOOD: Presentation only imports Domain
   import 'package:restaurant_app/features/auth/domain/entities/user.dart'; // CORRECT!
   ```

### Why This Matters

- **Testability**: Can test business logic without UI or APIs
- **Flexibility**: Can swap data sources without changing business logic
- **Maintainability**: Changes in one layer don't cascade everywhere

---

## Data Flow

### User Action → State Update Flow

```
1. User Interaction (UI)
   ↓
2. Widget calls Cubit method
   ↓
3. Cubit calls UseCase
   ↓
4. UseCase calls Repository (interface)
   ↓
5. Repository Implementation calls Service
   ↓
6. Service makes HTTP request
   ↓
7. Service returns JSON response
   ↓
8. Repository converts Model → Entity
   ↓
9. UseCase receives Entity
   ↓
10. Cubit emits new State with Entity
   ↓
11. Widget rebuilds with new State
```

### Concrete Example: User Login

```dart
// STEP 1: User taps "Login" button in UI
// File: lib/features/auth/presentation/widgets/login_form.dart
ElevatedButton(
  onPressed: () {
    context.read<AuthCubit>().login(email, password);
  },
  child: Text('Login'),
)

// STEP 2: Cubit receives login request
// File: lib/features/auth/presentation/cubit/auth_cubit.dart
Future<void> login(String email, String password) async {
  emit(AuthLoading()); // Show loading indicator

  // STEP 3: Call Domain UseCase
  final result = await _loginUseCase(email, password);

  // STEP 10: Map result to state
  result.fold(
    (error) => emit(AuthError(error)),
    (user) => emit(AuthAuthenticated(user)),
  );
}

// STEP 4: UseCase validates and delegates to repository
// File: lib/features/auth/domain/usecases/login_usecase.dart
Future<Either<String, User>> call(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    return const Left('Email and password are required');
  }

  // STEP 5: Call repository interface (Domain doesn't know about implementation)
  return await _repository.login(email, password);
}

// STEP 6: Repository calls service
// File: lib/features/auth/data/repositories/auth_repository_impl.dart
Future<Either<String, User>> login(String email, String password) async {
  try {
    // STEP 7: Service makes HTTP request
    final response = await _authService.login(
      email: email,
      password: password,
    );

    // STEP 8: Convert JSON → Model → Entity
    final userModel = UserModel.fromJson(response['user']);
    final user = userModel.toEntity(); // Model → Entity conversion

    // STEP 9: Return success to UseCase
    return Right(user);
  } on DioException catch (e) {
    return Left(ApiErrorHandler.handle(e));
  }
}

// STEP 11: Widget rebuilds
// File: lib/features/auth/presentation/widgets/login_form.dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    if (state is AuthAuthenticated) {
      return Text('Welcome ${state.user.fullName}');
    }
    if (state is AuthError) {
      return Text('Error: ${state.message}');
    }
    return LoginButton();
  },
)
```

---

## Real Example: Authentication Feature

### File Structure

```
lib/features/auth/
├── data/
│   ├── models/
│   │   ├── user_model.dart          # JSON ↔ Dart object
│   │   ├── auth_result_model.dart
│   │   └── auth_tokens_model.dart
│   ├── repositories/
│   │   └── auth_repository_impl.dart # Implements domain interface
│   └── services/
│       ├── auth_service.dart         # HTTP requests (PublicApiService)
│       └── profile_service.dart      # HTTP requests (BaseApiService)
├── domain/
│   ├── entities/
│   │   ├── user.dart                 # Pure business object
│   │   ├── auth_result.dart
│   │   └── auth_tokens.dart
│   ├── repositories/
│   │   └── auth_repository.dart      # Interface (contract)
│   └── usecases/
│       ├── login_usecase.dart        # One business operation
│       ├── register_usecase.dart
│       ├── logout_usecase.dart
│       └── google_sign_in_usecase.dart
└── presentation/
    ├── cubit/
    │   ├── auth_cubit.dart           # State management
    │   └── auth_state.dart           # State definitions
    ├── screens/
    │   ├── welcome_screen.dart       # Full-page UI
    │   └── forget_password_screen.dart
    └── widgets/
        ├── login_form.dart           # Reusable component
        └── register_form.dart
```

### Full Example: Register Feature

#### 1. Domain Layer (Business Logic)

```dart
// lib/features/auth/domain/entities/user.dart
@immutable
class User extends Equatable {
  final String id;
  final String email;
  final String fullName;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
  });

  @override
  List<Object> get props => [id, email, fullName];
}

// lib/features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Either<String, User>> register({
    required String email,
    required String password,
    required String fullName,
  });
}

// lib/features/auth/domain/usecases/register_usecase.dart
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Either<String, User>> call({
    required String email,
    required String password,
    required String fullName,
  }) async {
    // Business validation
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      return const Left('All fields are required');
    }

    if (!email.contains('@')) {
      return const Left('Invalid email format');
    }

    if (password.length < 8) {
      return const Left('Password must be at least 8 characters');
    }

    // Delegate to repository
    return await _repository.register(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
```

#### 2. Data Layer (Infrastructure)

```dart
// lib/features/auth/data/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String fullName;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
    );
  }
}

// lib/features/auth/data/services/auth_service.dart
class AuthService extends PublicApiService {
  AuthService(super.dio);

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
}

// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final AppPrefs _prefs;

  AuthRepositoryImpl(this._authService, this._prefs);

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
      final errorMessage = ApiErrorHandler.handle(e);
      return Left(errorMessage);
    }
  }
}
```

#### 3. Presentation Layer (UI & State)

```dart
// lib/features/auth/presentation/cubit/auth_state.dart
@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthRegistrationSuccess extends AuthState {
  final User user;

  const AuthRegistrationSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// lib/features/auth/presentation/cubit/auth_cubit.dart
class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase _registerUseCase;

  AuthCubit(this._registerUseCase) : super(AuthInitial());

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
}

// lib/features/auth/presentation/widgets/register_form.dart
class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegistrationSuccess) {
          // Navigate to home
          context.go('/home');
        }
        if (state is AuthError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Column(
          children: [
            CustomTextField(
              label: 'Full Name',
              onChanged: (value) => fullName = value,
            ),
            CustomTextField(
              label: 'Email',
              onChanged: (value) => email = value,
            ),
            CustomPasswordField(
              label: 'Password',
              onChanged: (value) => password = value,
            ),
            PrimaryButton(
              text: 'Register',
              isLoading: isLoading,
              onPressed: () {
                context.read<AuthCubit>().register(
                  email: email,
                  password: password,
                  fullName: fullName,
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

## Best Practices

### 1. Keep Domain Pure
```dart
// ❌ BAD: Domain depending on external packages
import 'package:dio/dio.dart'; // WRONG! Domain shouldn't know about HTTP

class LoginUseCase {
  Future<Response> call() { } // WRONG! Response is from Dio
}

// ✅ GOOD: Domain using only pure Dart
import 'package:dartz/dartz.dart'; // OK - functional programming utility

class LoginUseCase {
  Future<Either<String, User>> call() { } // GOOD! User is domain entity
}
```

### 2. One UseCase = One Operation
```dart
// ❌ BAD: Multiple operations in one UseCase
class AuthUseCase {
  Future<User> login() { }
  Future<User> register() { }
  Future<void> logout() { }
}

// ✅ GOOD: Separate UseCases
class LoginUseCase {
  Future<Either<String, User>> call() { }
}

class RegisterUseCase {
  Future<Either<String, User>> call() { }
}

class LogoutUseCase {
  Future<Either<String, void>> call() { }
}
```

### 3. Use Interfaces (Abstract Classes)
```dart
// ✅ GOOD: Define contract in Domain
abstract class AuthRepository {
  Future<Either<String, User>> login(String email, String password);
}

// ✅ GOOD: Implement in Data
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<String, User>> login(String email, String password) {
    // Implementation
  }
}
```

### 4. Convert Models to Entities
```dart
// ✅ GOOD: Always convert before returning to domain
Future<Either<String, User>> getUser() async {
  final response = await api.getUser();
  final model = UserModel.fromJson(response);

  return Right(model.toEntity()); // Convert to domain entity
}

// ❌ BAD: Returning models directly
Future<Either<String, UserModel>> getUser() async {
  final response = await api.getUser();
  return Right(UserModel.fromJson(response)); // WRONG! Should return User entity
}
```

### 5. Handle Errors Gracefully
```dart
// ✅ GOOD: Using Either for error handling
Future<Either<String, User>> login() async {
  try {
    final response = await service.login();
    return Right(response.toEntity());
  } on DioException catch (e) {
    return Left(ApiErrorHandler.handle(e));
  } catch (e) {
    return Left('An unexpected error occurred');
  }
}
```

---

## Testing Strategy

### Unit Tests
- **Domain Layer**: Test UseCases with mocked repositories
- **Data Layer**: Test repositories with mocked services
- **Presentation Layer**: Test Cubits with mocked UseCases

### Example: Testing LoginUseCase
```dart
void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
  });

  test('should return error when email is empty', () async {
    // Act
    final result = await loginUseCase('', 'password');

    // Assert
    expect(result, isA<Left>());
    expect(result.fold((l) => l, (r) => ''), 'Email and password are required');
  });

  test('should call repository when credentials are valid', () async {
    // Arrange
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => const Right(User(...)));

    // Act
    await loginUseCase('test@example.com', 'password123');

    // Assert
    verify(() => mockRepository.login('test@example.com', 'password123'));
  });
}
```

---

## Summary

Clean Architecture in BiteGo provides:

✅ **Clear Separation** - Each layer has one responsibility
✅ **Testability** - Easy to test each layer independently
✅ **Flexibility** - Can swap implementations without breaking code
✅ **Maintainability** - Changes are localized to specific layers
✅ **Scalability** - New features follow established patterns

**Remember**:
- Domain = Business logic (pure Dart, no dependencies)
- Data = Infrastructure (APIs, databases, storage)
- Presentation = UI and state management

**Dependency Flow**: Presentation → Domain ← Data
