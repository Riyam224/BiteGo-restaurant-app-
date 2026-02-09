import 'package:dartz/dartz.dart';
import 'package:restaurant_app/features/auth/domain/entities/user.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<String, User>> call({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }
}
