import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:restaurant_app/core/networking/dio_client.dart';
import 'package:restaurant_app/core/storage/secure_storage_service.dart';
import 'package:restaurant_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:restaurant_app/features/auth/data/services/auth_service.dart';
import 'package:restaurant_app/features/auth/data/services/google_auth_service.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurant_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:restaurant_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:restaurant_app/features/products/data/repositories/products_repository_impl.dart';
import 'package:restaurant_app/features/products/data/services/products_service.dart';
import 'package:restaurant_app/features/products/domain/repositories/products_repository.dart';
import 'package:restaurant_app/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:restaurant_app/features/products/domain/usecases/get_product_details_usecase.dart';
import 'package:restaurant_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:restaurant_app/features/products/presentation/cubit/products_cubit.dart';

/// Service Locator for Dependency Injection
/// Using GetIt for clean, testable architecture
final sl = GetIt.instance;

/// Initialize all dependencies
/// Call this in main() before runApp()
Future<void> initializeDependencies() async {
  // ==================== CORE ====================
  await _registerCore();

  // ==================== FEATURES ====================
  await _registerAuth();
  await _registerProducts();
}

/// Register core dependencies (Storage, Network, etc.)
Future<void> _registerCore() async {
  // Secure Storage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ),
  );

  sl.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(sl()),
  );

  // Dio Clients (Public and Protected)
  sl.registerLazySingleton<Dio>(
    () => DioClient.createPublicDio(),
    instanceName: 'publicDio',
  );

  sl.registerLazySingleton<Dio>(
    () => DioClient.createProtectedDio(sl<SecureStorageService>()),
    instanceName: 'protectedDio',
  );
}

/// Register Authentication dependencies
Future<void> _registerAuth() async {
  // Services
  sl.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  sl.registerLazySingleton<GoogleAuthService>(
    () => GoogleAuthService(),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthService>(),
      sl<GoogleAuthService>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  // Cubit (Factory - new instance each time)
  sl.registerFactory(
    () => AuthCubit(
      registerUseCase: sl(),
      loginUseCase: sl(),
      googleSignInUseCase: sl(),
      logoutUseCase: sl(),
      forgotPasswordUseCase: sl(),
      verifyOtpUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );
}

/// Register Products dependencies
Future<void> _registerProducts() async {
  // Services
  sl.registerLazySingleton<ProductsService>(
    () => ProductsService(),
  );

  // Repository
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(sl<ProductsService>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => ProductsCubit(
      getProductsUseCase: sl(),
      getCategoriesUseCase: sl(),
      getProductDetailsUseCase: sl(),
    ),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
  await initializeDependencies();
}
