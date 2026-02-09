import 'package:dartz/dartz.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<Either<String, void>> call({
    required String email,
  }) async {
    return await repository.forgotPassword(email: email);
  }
}
