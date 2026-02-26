# API Integration Implementation Guide

This guide shows how to use the new API integration with Cubit state management, dependency injection, and secure storage.

---

## ✅ What's Been Implemented

### 1. **Secure Storage Service**
- ✅ Created `/lib/core/storage/secure_storage_service.dart`
- ✅ Manages JWT tokens securely using `flutter_secure_storage`
- ✅ Methods: `saveAccessToken()`, `getAccessToken()`, `saveRefreshToken()`, `clearTokens()`, etc.

### 2. **Dependency Injection (GetIt)**
- ✅ Created `/lib/core/di/injection.dart`
- ✅ Centralized DI for all services, repositories, use cases, and cubits
- ✅ Separate Dio instances for public and protected endpoints

### 3. **Products Feature (Clean Architecture)**
- ✅ **Domain Layer:**
  - Repository interface: `products_repository.dart`
  - Use cases: `get_products_usecase.dart`, `get_categories_usecase.dart`, `get_product_details_usecase.dart`

- ✅ **Data Layer:**
  - Service: `products_service.dart` (API calls)
  - Repository implementation: `products_repository_impl.dart`

- ✅ **Presentation Layer:**
  - Cubit: `products_cubit.dart`
  - States: `products_state.dart`

### 4. **Updated Dependencies**
- ✅ Added `flutter_secure_storage: ^9.2.2`
- ✅ Added `get_it: ^8.0.3`
- ✅ Updated `DioClient` to use `SecureStorageService`

---

## 🚀 How to Initialize

### Step 1: Update `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:restaurant_app/core/di/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (if using)
  // await Firebase.initializeApp();

  // ✅ Initialize Dependency Injection
  await di.initializeDependencies();

  runApp(const MyApp());
}
```

---

## 📦 How to Use in Your Screens

### Example 1: Using ProductsCubit in Home Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/di/injection.dart';
import 'package:restaurant_app/features/products/presentation/cubit/products_cubit.dart';
import 'package:restaurant_app/features/products/presentation/cubit/products_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Get cubit from DI
      create: (_) => sl<ProductsCubit>()..loadProducts(),
      child: Scaffold(
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductsError) {
              return Center(child: Text(state.message));
            }

            if (state is ProductsLoaded) {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ListTile(
                    leading: Image.network(product.imageUrl),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price}'),
                    onTap: () {
                      // Navigate to product details
                      context.push('/product-details', extra: product);
                    },
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
```

### Example 2: Search Products

```dart
// In your search widget
TextField(
  onChanged: (query) {
    context.read<ProductsCubit>().searchProducts(query);
  },
  decoration: const InputDecoration(
    hintText: 'Search products...',
  ),
)
```

### Example 3: Filter by Category

```dart
// When category is selected
ElevatedButton(
  onPressed: () {
    context.read<ProductsCubit>().filterByCategory(categoryId);
  },
  child: Text(category.name),
)
```

### Example 4: Load Categories

```dart
class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductsCubit>()..loadCategories(),
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const CircularProgressIndicator();
          }

          if (state is CategoriesLoaded) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return CategoryCard(category: category);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
```

---

## 🔐 Using Auth with Secure Storage

### Login Flow

```dart
// After successful login
final response = await authService.login(email, password);

// Save tokens securely
await sl<SecureStorageService>().saveTokens(
  accessToken: response.accessToken,
  refreshToken: response.refreshToken,
);

// Save user data
await sl<SecureStorageService>().saveUserData(
  userId: response.user.id,
  email: response.user.email,
);
```

### Logout Flow

```dart
// Clear all tokens
await sl<SecureStorageService>().clearTokens();

// Navigate to login
context.go('/login');
```

### Check if User is Logged In

```dart
final hasTokens = await sl<SecureStorageService>().hasValidTokens();

if (hasTokens) {
  // Navigate to home
} else {
  // Navigate to login
}
```

---

## 🔄 Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    await context.read<ProductsCubit>().refreshProducts();
  },
  child: ProductsList(),
)
```

---

## 📊 Available Sort Options

```dart
// Sort by price ascending
context.read<ProductsCubit>().sortProducts('price_asc');

// Sort by price descending
context.read<ProductsCubit>().sortProducts('price_desc');

// Sort by name
context.read<ProductsCubit>().sortProducts('name');

// Sort by newest
context.read<ProductsCubit>().sortProducts('newest');
```

---

## 🎯 Available Filter Options

```dart
// Filter by price range
context.read<ProductsCubit>().filterByPrice(
  minPrice: 10.0,
  maxPrice: 50.0,
);

// Filter by category
context.read<ProductsCubit>().filterByCategory(categoryId);

// Combined filters
context.read<ProductsCubit>().loadProducts(
  search: 'pizza',
  categoryId: 1,
  minPrice: 15.0,
  maxPrice: 30.0,
  sortBy: 'price_asc',
);
```

---

## 🏗️ Architecture Overview

```
lib/
├── core/
│   ├── di/
│   │   └── injection.dart              # Dependency Injection setup
│   ├── storage/
│   │   └── secure_storage_service.dart # Secure token storage
│   └── networking/
│       ├── dio_client.dart             # HTTP client factory
│       ├── endpoints.dart               # API endpoint constants
│       ├── public_api_service.dart      # Base for public APIs
│       └── base_api_service.dart        # Base for protected APIs
│
└── features/
    ├── products/
    │   ├── domain/
    │   │   ├── repositories/
    │   │   │   └── products_repository.dart
    │   │   └── usecases/
    │   │       ├── get_products_usecase.dart
    │   │       ├── get_categories_usecase.dart
    │   │       └── get_product_details_usecase.dart
    │   ├── data/
    │   │   ├── services/
    │   │   │   └── products_service.dart
    │   │   └── repositories/
    │   │       └── products_repository_impl.dart
    │   └── presentation/
    │       └── cubit/
    │           ├── products_cubit.dart
    │           └── products_state.dart
    │
    └── auth/
        └── ... (similar structure)
```

---

## ✨ SOLID Principles Applied

1. **Single Responsibility**: Each class has one reason to change
   - Services: API calls only
   - Repositories: Data mapping only
   - Use Cases: Business logic only
   - Cubits: State management only

2. **Open/Closed**: Open for extension, closed for modification
   - Easy to add new endpoints without modifying existing code
   - Easy to add new features by extending base classes

3. **Liskov Substitution**: Interfaces can be replaced with implementations
   - `ProductsRepository` interface → `ProductsRepositoryImpl`

4. **Interface Segregation**: Specific interfaces for specific needs
   - `PublicApiService` for public endpoints
   - `BaseApiService` for protected endpoints

5. **Dependency Inversion**: Depend on abstractions, not concretions
   - Cubits depend on use cases (abstractions)
   - Use cases depend on repositories (abstractions)
   - DI provides concrete implementations

---

## 🧪 Testing

The architecture makes testing easy:

```dart
// Mock the repository
class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late ProductsCubit cubit;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    final useCase = GetProductsUseCase(mockRepository);
    cubit = ProductsCubit(
      getProductsUseCase: useCase,
      getCategoriesUseCase: ...,
      getProductDetailsUseCase: ...,
    );
  });

  test('should emit ProductsLoaded when products are fetched', () async {
    // Arrange
    when(mockRepository.getProducts())
        .thenAnswer((_) async => Right([product1, product2]));

    // Act
    await cubit.loadProducts();

    // Assert
    expect(cubit.state, isA<ProductsLoaded>());
  });
}
```

---

## 🔧 Next Steps

1. ✅ Initialize DI in `main.dart`
2. ✅ Update `HomeScreen` to use `ProductsCubit`
3. ✅ Implement other features (Cart, Orders, Auth)
4. ✅ Add error handling UI
5. ✅ Add loading states
6. ✅ Implement token refresh logic
7. ✅ Add unit tests

---

## 📚 Additional Resources

- [API Reference](API_REFERENCE.md)
- [API Endpoints Summary](API_ENDPOINTS_SUMMARY.md)
- [Flutter Bloc Documentation](https://bloclibrary.dev/)
- [GetIt Documentation](https://pub.dev/packages/get_it)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
