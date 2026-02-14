# State Management with Flutter Bloc (Cubit)

> Comprehensive guide to state management using Flutter Bloc's Cubit pattern in BiteGo

## Table of Contents

- [What is Flutter Bloc?](#what-is-flutter-bloc)
- [Cubit vs BLoC](#cubit-vs-bloc)
- [Core Concepts](#core-concepts)
- [AuthCubit Implementation](#authcubit-implementation)
- [State Definitions](#state-definitions)
- [Using Cubit in UI](#using-cubit-in-ui)
- [Best Practices](#best-practices)
- [Testing Cubits](#testing-cubits)

## What is Flutter Bloc?

Flutter Bloc is a state management library that helps separate presentation from business logic. It implements the **BLoC (Business Logic Component)** pattern, which uses streams to manage state.

### Why Flutter Bloc?

- ✅ **Predictable** - State changes are explicit and traceable
- ✅ **Testable** - Business logic is decoupled from UI
- ✅ **Reusable** - Same Cubit can be used across multiple widgets
- ✅ **Reactive** - UI automatically updates when state changes
- ✅ **Debuggable** - Built-in dev tools for time-travel debugging

### Key Benefits in BiteGo

```dart
// Without Bloc: Stateful widget with mixed concerns
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  String? errorMessage;
  User? user;

  Future<void> login() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(...); // Mixed UI and business logic
      final user = User.fromJson(response);
      setState(() {
        isLoading = false;
        this.user = user;
      });
      Navigator.push(...); // Navigation logic in widget
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading) CircularProgressIndicator(),
        if (errorMessage != null) Text(errorMessage!),
        ElevatedButton(onPressed: login, child: Text('Login')),
      ],
    );
  }
}

// With Bloc: Clean separation
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(loginUseCase),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home'); // Centralized navigation
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CircularProgressIndicator();
          }
          if (state is AuthError) {
            return Text(state.message);
          }
          return ElevatedButton(
            onPressed: () => context.read<AuthCubit>().login(email, password),
            child: Text('Login'),
          );
        },
      ),
    );
  }
}
```

---

## Cubit vs BLoC

Flutter Bloc offers two patterns: **Cubit** and **Bloc**. BiteGo uses **Cubit** for simplicity.

### Cubit (Used in BiteGo)

- **Simpler** - Expose methods directly
- **Less boilerplate** - No events to define
- **Function-based** - Call `cubit.login()` directly
- **Best for**: Straightforward state changes

```dart
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // Direct method calls
  void login(String email, String password) async {
    emit(AuthLoading());
    // ... business logic
    emit(AuthAuthenticated(user));
  }
}

// Usage
cubit.login('test@example.com', 'password123'); // Simple!
```

### Bloc (Not used in BiteGo)

- **Event-based** - Dispatch events instead of calling methods
- **More boilerplate** - Define events and handlers
- **Best for**: Complex event transformations, event debouncing

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      // ... business logic
      emit(AuthAuthenticated(user));
    });
  }
}

// Usage (more verbose)
bloc.add(LoginRequested(email: 'test@example.com', password: 'password123'));
```

**We chose Cubit because**:
- Simpler API for our use cases
- Less code to write and maintain
- Easier for new developers to understand

---

## Core Concepts

### 1. Cubit

A **Cubit** is a class that manages state and exposes methods to change that state.

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0); // Initial state = 0

  void increment() => emit(state + 1); // Change state
  void decrement() => emit(state - 1);
}
```

**Key Points**:
- Extends `Cubit<StateType>`
- Constructor takes initial state
- Use `emit()` to change state
- Current state accessed via `state` property

### 2. State

States are **immutable** objects representing UI state at a point in time.

```dart
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

**Best Practices**:
- States extend `Equatable` for automatic equality comparison
- States are immutable (`@immutable` annotation)
- Use `const` constructors where possible
- Override `props` getter to define equality

### 3. BlocProvider

Provides a Cubit instance to the widget tree.

```dart
BlocProvider(
  create: (context) => AuthCubit(loginUseCase),
  child: WelcomeScreen(),
)
```

**Scoping**:
- Cubit is available to all descendants
- Automatically disposed when widget is removed
- Use `BlocProvider.value` to provide existing instance

### 4. BlocBuilder

Rebuilds widget when state changes.

```dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    if (state is AuthAuthenticated) {
      return Text('Welcome ${state.user.fullName}');
    }
    return LoginButton();
  },
)
```

### 5. BlocListener

Performs side effects in response to state changes (navigation, dialogs, snackbars).

```dart
BlocListener<AuthCubit, AuthState>(
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
  child: LoginForm(),
)
```

### 6. BlocConsumer

Combines `BlocBuilder` + `BlocListener`.

```dart
BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    // Side effects (navigation, dialogs)
    if (state is AuthError) {
      showDialog(...);
    }
  },
  builder: (context, state) {
    // Build UI based on state
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    return LoginButton();
  },
)
```

---

## AuthCubit Implementation

### File Structure

```
lib/features/auth/presentation/cubit/
├── auth_cubit.dart     # Business logic controller
└── auth_state.dart     # State definitions
```

### AuthCubit Class

**Location**: [lib/features/auth/presentation/cubit/auth_cubit.dart](../lib/features/auth/presentation/cubit/auth_cubit.dart)

```dart
class AuthCubit extends Cubit<AuthState> {
  // Dependencies (injected via constructor)
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthCubit({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _googleSignInUseCase = googleSignInUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        super(AuthInitial()); // Initial state

  // ===== Registration =====
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(AuthLoading()); // Show loading indicator

    final result = await _registerUseCase(
      email: email,
      password: password,
      fullName: fullName,
    );

    result.fold(
      (error) => emit(AuthError(error)), // Error case
      (user) => emit(AuthRegistrationSuccess(user)), // Success case
    );
  }

  // ===== Login =====
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _loginUseCase(
      email: email,
      password: password,
    );

    result.fold(
      (error) => emit(AuthError(error)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  // ===== Google Sign-In =====
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    final result = await _googleSignInUseCase();

    result.fold(
      (error) => emit(AuthError(error)),
      (user) => emit(AuthGoogleSignInSuccess(user)),
    );
  }

  // ===== Logout =====
  Future<void> logout() async {
    emit(AuthLoading());

    final result = await _logoutUseCase();

    result.fold(
      (error) => emit(AuthError(error)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  // ===== Forgot Password =====
  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());

    final result = await _forgotPasswordUseCase(email);

    result.fold(
      (error) => emit(AuthError(error)),
      (_) => emit(AuthOtpSent(email)),
    );
  }

  // ===== Verify OTP =====
  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    emit(AuthLoading());

    final result = await _verifyOtpUseCase(
      email: email,
      otp: otp,
    );

    result.fold(
      (error) => emit(AuthError(error)),
      (_) => emit(AuthOtpVerified(email)),
    );
  }

  // ===== Reset Password =====
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    emit(AuthLoading());

    final result = await _resetPasswordUseCase(
      email: email,
      newPassword: newPassword,
    );

    result.fold(
      (error) => emit(AuthError(error)),
      (_) => emit(AuthPasswordResetSuccess()),
    );
  }
}
```

### Key Patterns

#### 1. Dependency Injection
```dart
// Dependencies injected via constructor (NOT created inside Cubit)
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
  }) : _loginUseCase = loginUseCase,
       super(AuthInitial());
}
```

**Why?** Enables testing with mock dependencies.

#### 2. Initial State
```dart
super(AuthInitial()); // Always provide initial state
```

#### 3. Loading State Pattern
```dart
Future<void> login() async {
  emit(AuthLoading()); // Always emit loading first

  final result = await _loginUseCase();

  result.fold(
    (error) => emit(AuthError(error)),
    (user) => emit(AuthAuthenticated(user)),
  );
}
```

#### 4. Either Pattern for Error Handling
```dart
result.fold(
  (error) => emit(AuthError(error)),    // Left = error
  (user) => emit(AuthAuthenticated(user)), // Right = success
);
```

---

## State Definitions

**Location**: [lib/features/auth/presentation/cubit/auth_state.dart](../lib/features/auth/presentation/cubit/auth_state.dart)

### Base State Class

```dart
@immutable
abstract class AuthState extends Equatable {
  const AuthState();
}
```

**All states must**:
- Extend `AuthState`
- Be immutable (`@immutable` or `const`)
- Override `props` getter for equality

### State Catalog

#### 1. AuthInitial

**Purpose**: Starting state before any action.

```dart
class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object> get props => [];
}
```

**UI Response**: Show login/register form.

---

#### 2. AuthLoading

**Purpose**: Async operation in progress.

```dart
class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object> get props => [];
}
```

**UI Response**: Show loading indicator, disable buttons.

---

#### 3. AuthAuthenticated

**Purpose**: User successfully logged in.

```dart
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}
```

**UI Response**: Navigate to home screen.

---

#### 4. AuthUnauthenticated

**Purpose**: User logged out or session expired.

```dart
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  List<Object> get props => [];
}
```

**UI Response**: Navigate to welcome screen.

---

#### 5. AuthError

**Purpose**: Operation failed with error message.

```dart
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
```

**UI Response**: Show error snackbar/dialog.

---

#### 6. AuthRegistrationSuccess

**Purpose**: Registration completed successfully.

```dart
class AuthRegistrationSuccess extends AuthState {
  final User user;

  const AuthRegistrationSuccess(this.user);

  @override
  List<Object> get props => [user];
}
```

**UI Response**: Show success dialog, navigate to home.

---

#### 7. AuthLoginSuccess

**Purpose**: Login completed successfully (alternative to AuthAuthenticated).

```dart
class AuthLoginSuccess extends AuthState {
  final User user;

  const AuthLoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}
```

---

#### 8. AuthGoogleSignInSuccess

**Purpose**: Google Sign-In completed.

```dart
class AuthGoogleSignInSuccess extends AuthState {
  final User user;

  const AuthGoogleSignInSuccess(this.user);

  @override
  List<Object> get props => [user];
}
```

---

#### 9. AuthOtpSent

**Purpose**: OTP sent to email for password reset.

```dart
class AuthOtpSent extends AuthState {
  final String email;

  const AuthOtpSent(this.email);

  @override
  List<Object> get props => [email];
}
```

**UI Response**: Navigate to OTP verification screen.

---

#### 10. AuthOtpVerified

**Purpose**: OTP verified successfully.

```dart
class AuthOtpVerified extends AuthState {
  final String email;

  const AuthOtpVerified(this.email);

  @override
  List<Object> get props => [email];
}
```

**UI Response**: Navigate to reset password screen.

---

#### 11. AuthPasswordResetSuccess

**Purpose**: Password reset completed.

```dart
class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();

  @override
  List<Object> get props => [];
}
```

**UI Response**: Show success message, navigate to login.

---

## Using Cubit in UI

### Pattern 1: BlocProvider (Providing Cubit)

**Provide at screen level:**

```dart
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Create Cubit with dependencies
        final dependencies = AuthDependencies.create();
        return AuthCubit(
          registerUseCase: dependencies.registerUseCase,
          loginUseCase: dependencies.loginUseCase,
          // ... other dependencies
        );
      },
      child: WelcomeScreenContent(),
    );
  }
}
```

**Provide globally (in MaterialApp):**

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (_) => AuthCubit(...),
    ),
    BlocProvider(
      create: (_) => ThemeController(),
    ),
  ],
  child: MaterialApp(...),
)
```

---

### Pattern 2: BlocBuilder (Reactive UI)

**Build UI based on state:**

```dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    // Check state type and build accordingly
    if (state is AuthLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (state is AuthError) {
      return Column(
        children: [
          Text('Error: ${state.message}'),
          LoginForm(),
        ],
      );
    }

    if (state is AuthAuthenticated) {
      return Text('Welcome ${state.user.fullName}');
    }

    // Default: Initial state
    return LoginForm();
  },
)
```

**Conditional rebuilds (buildWhen):**

```dart
BlocBuilder<AuthCubit, AuthState>(
  buildWhen: (previous, current) {
    // Only rebuild when transitioning from loading to success/error
    return current is! AuthLoading;
  },
  builder: (context, state) {
    // ...
  },
)
```

---

### Pattern 3: BlocListener (Side Effects)

**Navigate, show dialogs, snackbars:**

```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthError) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (state is AuthAuthenticated) {
      // Navigate to home
      context.go('/home');
    }

    if (state is AuthRegistrationSuccess) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (_) => SuccessDialog(
          message: 'Registration successful!',
        ),
      );
    }
  },
  child: LoginForm(),
)
```

**Conditional listeners (listenWhen):**

```dart
BlocListener<AuthCubit, AuthState>(
  listenWhen: (previous, current) {
    // Only listen when error occurs
    return current is AuthError;
  },
  listener: (context, state) {
    showErrorDialog(state.message);
  },
  child: LoginForm(),
)
```

---

### Pattern 4: BlocConsumer (Combined)

**Most common pattern in BiteGo:**

```dart
BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    // Handle side effects
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
    // Build UI
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
)
```

---

### Pattern 5: Accessing Cubit

#### Read (One-time access)
```dart
// Get cubit instance to call methods
final cubit = context.read<AuthCubit>();
cubit.login(email, password);

// Inline
context.read<AuthCubit>().login(email, password);
```

**Use when**: Calling methods (button onPressed, etc.)

#### Watch (Listen to changes)
```dart
// Rebuilds widget when state changes
final state = context.watch<AuthCubit>().state;

if (state is AuthLoading) {
  return CircularProgressIndicator();
}
```

**Use when**: Need current state in build method.

#### Select (Listen to specific property)
```dart
// Only rebuilds when user changes
final user = context.select((AuthCubit cubit) =>
  cubit.state is AuthAuthenticated
    ? (cubit.state as AuthAuthenticated).user
    : null
);
```

**Use when**: Optimizing rebuilds for specific properties.

---

## Best Practices

### 1. Always Emit Loading First

```dart
// ✅ GOOD
Future<void> login() async {
  emit(AuthLoading()); // User sees loading indicator immediately

  final result = await _loginUseCase();
  // ...
}

// ❌ BAD
Future<void> login() async {
  final result = await _loginUseCase(); // No loading indicator!
  emit(AuthLoading()); // Too late!
}
```

---

### 2. Use Equatable for State Equality

```dart
// ✅ GOOD
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user]; // Auto equality check
}

// ❌ BAD (without Equatable)
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  // BlocBuilder will rebuild even if user hasn't changed!
}
```

**Why?** Prevents unnecessary rebuilds when state hasn't actually changed.

---

### 3. Make States Immutable

```dart
// ✅ GOOD
@immutable
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user); // const constructor
}

// ❌ BAD
class AuthAuthenticated extends AuthState {
  User user; // Mutable!

  AuthAuthenticated(this.user);

  void updateUser(User newUser) {
    user = newUser; // This breaks state management!
  }
}
```

**Why?** Immutability ensures state changes are explicit via `emit()`.

---

### 4. Don't Access Cubit in Build Method

```dart
// ❌ BAD
@override
Widget build(BuildContext context) {
  final cubit = context.read<AuthCubit>();

  return ElevatedButton(
    onPressed: cubit.login, // Fine here
  );
}

// ✅ GOOD
@override
Widget build(BuildContext context) {
  return BlocBuilder<AuthCubit, AuthState>(
    builder: (context, state) {
      // Use state, not cubit
      if (state is AuthLoading) {
        return CircularProgressIndicator();
      }
      return LoginButton();
    },
  );
}
```

---

### 5. Close/Dispose Cubit Properly

```dart
// BlocProvider automatically disposes
BlocProvider(
  create: (_) => AuthCubit(...),
  child: WelcomeScreen(),
) // Cubit.close() called when widget removed

// Manual disposal (if creating cubit manually)
class _MyScreenState extends State<MyScreen> {
  late final AuthCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AuthCubit(...);
  }

  @override
  void dispose() {
    _cubit.close(); // MUST call close()
    super.dispose();
  }
}
```

---

### 6. Separate Business Logic from UI Logic

```dart
// ❌ BAD: Business logic in Cubit
class AuthCubit extends Cubit<AuthState> {
  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    // Don't do this!
    final response = await http.post(
      Uri.parse('https://api.example.com/login'),
      body: {'email': email, 'password': password},
    );

    final user = User.fromJson(jsonDecode(response.body));
    emit(AuthAuthenticated(user));
  }
}

// ✅ GOOD: Delegate to UseCase
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthCubit(this._loginUseCase);

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await _loginUseCase(email, password);

    result.fold(
      (error) => emit(AuthError(error)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
```

---

### 7. Handle All State Types

```dart
// ✅ GOOD: Handle all states
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) return CircularProgressIndicator();
    if (state is AuthError) return ErrorWidget(state.message);
    if (state is AuthAuthenticated) return HomeScreen();
    return LoginScreen(); // Default case
  },
)

// ❌ BAD: Missing states
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) return CircularProgressIndicator();
    return LoginScreen(); // What if state is AuthError?
  },
)
```

---

## Testing Cubits

### Unit Testing

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late AuthCubit authCubit;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    authCubit = AuthCubit(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    test('initial state is AuthInitial', () {
      expect(authCubit.state, equals(AuthInitial()));
    });

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(() => mockLoginUseCase(any(), any()))
            .thenAnswer((_) async => Right(User(...)));
        return authCubit;
      },
      act: (cubit) => cubit.login('test@example.com', 'password123'),
      expect: () => [
        AuthLoading(),
        AuthAuthenticated(User(...)),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(() => mockLoginUseCase(any(), any()))
            .thenAnswer((_) async => Left('Invalid credentials'));
        return authCubit;
      },
      act: (cubit) => cubit.login('test@example.com', 'wrong'),
      expect: () => [
        AuthLoading(),
        AuthError('Invalid credentials'),
      ],
    );
  });
}
```

---

## Summary

### Key Takeaways

✅ **Cubit** - Manages state, exposes methods
✅ **States** - Immutable, extend Equatable
✅ **BlocProvider** - Provides cubit to widget tree
✅ **BlocBuilder** - Rebuilds on state changes
✅ **BlocListener** - Side effects (navigation, dialogs)
✅ **BlocConsumer** - Combines builder + listener

### State Flow

```
User Action → Cubit Method → UseCase → Repository
                ↓
           Emit Loading
                ↓
           Emit Success/Error
                ↓
         BlocBuilder Rebuilds UI
```

### When to Use What

| Widget | Purpose | Example |
|--------|---------|---------|
| **BlocProvider** | Provide cubit | Screen-level provider |
| **BlocBuilder** | Reactive UI | Show loading/success/error states |
| **BlocListener** | Side effects | Navigate, show snackbar |
| **BlocConsumer** | Both | Login form (show loading + navigate) |
| **context.read** | Call methods | Button onPressed |
| **context.watch** | Get current state | Conditional rendering |

---

**Next Steps**: See [AUTHENTICATION.md](AUTHENTICATION.md) for complete auth flow implementation.
