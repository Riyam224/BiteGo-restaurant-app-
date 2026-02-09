import 'package:dartz/dartz.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<String, void>> call() async {
    return await repository.logout();
  }
}
