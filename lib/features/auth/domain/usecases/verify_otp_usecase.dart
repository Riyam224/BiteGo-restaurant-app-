import 'package:dartz/dartz.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<String, void>> call({
    required String email,
    required String otp,
  }) async {
    return await repository.verifyOtp(email: email, otp: otp);
  }
}
