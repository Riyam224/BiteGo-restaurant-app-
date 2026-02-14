import 'package:dartz/dartz.dart';
import 'package:restaurant_app/features/auth/domain/entities/auth_result.dart';
import 'package:restaurant_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, User>> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  });

  Future<Either<String, AuthResult>> login({
    required String email,
    required String password,
  });

  Future<Either<String, void>> forgotPassword({
    required String email,
  });

  Future<Either<String, void>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<String, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<Either<String, AuthResult>> signInWithGoogle();

  Future<Either<String, void>> logout();
}
