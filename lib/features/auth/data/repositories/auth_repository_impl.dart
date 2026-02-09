import 'package:dartz/dartz.dart';
import 'package:restaurant_app/core/storage/shared_prefs.dart';
import 'package:restaurant_app/core/utils/app_logger.dart';
import 'package:restaurant_app/features/auth/data/models/auth_result_model.dart';
import 'package:restaurant_app/features/auth/data/models/user_model.dart';
import 'package:restaurant_app/features/auth/data/services/auth_service.dart';
import 'package:restaurant_app/features/auth/domain/entities/auth_result.dart';
import 'package:restaurant_app/features/auth/domain/entities/user.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

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
  Future<Either<String, void>> logout() async {
    try {
      await AppPrefs.clearTokens();
      return const Right(null);
    } catch (error) {
      return Left(error.toString());
    }
  }
}
