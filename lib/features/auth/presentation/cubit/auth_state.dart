import 'package:equatable/equatable.dart';
import 'package:restaurant_app/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthRegistrationSuccess extends AuthState {
  final User user;

  const AuthRegistrationSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthLoginSuccess extends AuthState {
  final User user;

  const AuthLoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthGoogleSignInSuccess extends AuthState {
  final User user;

  const AuthGoogleSignInSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthOtpSent extends AuthState {
  final String email;

  const AuthOtpSent(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthOtpVerified extends AuthState {
  final String email;

  const AuthOtpVerified(this.email);

  @override
  List<Object?> get props => [email];
}

class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}
