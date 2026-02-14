import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/storage/shared_prefs.dart';
import 'package:restaurant_app/core/utils/app_logger.dart';
import 'package:restaurant_app/features/auth/data/models/auth_result_model.dart';
import 'package:restaurant_app/features/auth/data/models/user_model.dart';
import 'package:restaurant_app/features/auth/data/services/auth_service.dart';
import 'package:restaurant_app/features/auth/data/services/google_auth_service.dart';
import 'package:restaurant_app/features/auth/domain/entities/auth_result.dart';
import 'package:restaurant_app/features/auth/domain/entities/user.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final GoogleAuthService _googleAuthService;

  AuthRepositoryImpl(this._authService, this._googleAuthService);

  @override
  Future<Either<String, User>> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    try {
      final response = await _authService.register(
        email: email,
        password: password,
        phone: phone,
      );

      final userData = response.data['data'] ?? response.data;
      final user = UserModel.fromJson(userData);

      AppLogger.auth('Registration successful for: ${user.email} (ID: ${user.id})');
      return Right(user);
    } catch (error) {
      AppLogger.error('Registration failed: $error');
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, AuthResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      final authResult = AuthResultModel.fromJson(response.data);

      await AppPrefs.setTokens(
        accessToken: authResult.tokens.accessToken,
        refreshToken: authResult.tokens.refreshToken,
      );

      return Right(authResult);
    } catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, void>> forgotPassword({
    required String email,
  }) async {
    try {
      await _authService.forgotPassword(email: email);
      return const Right(null);
    } catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _authService.verifyOtp(
        email: email,
        otp: otp,
      );
      return const Right(null);
    } catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _authService.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      return const Right(null);
    } catch (error) {
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, AuthResult>> signInWithGoogle() async {
    try {
      AppLogger.info('Starting Google Sign-In flow');

      // Step 1: Get Firebase ID token via GoogleAuthService
      final String firebaseIdToken =
          await _googleAuthService.signInWithGoogle();

      AppLogger.info('Firebase ID token obtained, authenticating with backend');

      // Step 2: Send Firebase ID token to backend for authentication
      final response = await _authService.googleSignIn(
        idToken: firebaseIdToken,
      );

      // Step 3: Parse the response
      final authResult = AuthResultModel.fromJson(response.data);

      // Step 4: Store tokens
      await AppPrefs.setTokens(
        accessToken: authResult.tokens.accessToken,
        refreshToken: authResult.tokens.refreshToken,
      );

      AppLogger.auth(
          'Google Sign-In successful for: ${authResult.user.email} (ID: ${authResult.user.id})');

      return Right(authResult);
    } catch (error) {
      AppLogger.error('Google Sign-In failed: $error');
      return Left(error.toString());
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      // Sign out from Google and Firebase as well
      await _googleAuthService.signOut();
      await AppPrefs.clearTokens();
      return const Right(null);
    } catch (error) {
      return Left(error.toString());
    }
  }
}
