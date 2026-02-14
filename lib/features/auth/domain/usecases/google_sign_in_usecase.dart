import 'package:dartz/dartz.dart';
import 'package:restaurant_app/features/auth/domain/entities/auth_result.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';

/// Google Sign-In Use Case
/// Follows Single Responsibility Principle - only handles Google sign-in business logic
/// Implements Dependency Inversion Principle - depends on abstraction (AuthRepository)
class GoogleSignInUseCase {
  final AuthRepository _repository;

  GoogleSignInUseCase(this._repository);

  Future<Either<String, AuthResult>> call() async {
    return await _repository.signInWithGoogle();
  }
}
