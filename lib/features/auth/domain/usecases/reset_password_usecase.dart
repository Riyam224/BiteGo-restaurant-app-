import 'package:dartz/dartz.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<String, void>> call({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    return await repository.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
  }
}
