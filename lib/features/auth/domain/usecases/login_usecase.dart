import 'package:dartz/dartz.dart';
import 'package:restaurant_app/features/auth/domain/entities/auth_result.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<String, AuthResult>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(
      email: email,
      password: password,
    );
  }
}
