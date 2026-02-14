import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:restaurant_app/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RegisterUseCase _registerUseCase;
  final LoginUseCase _loginUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final LogoutUseCase _logoutUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthCubit({
    required RegisterUseCase registerUseCase,
    required LoginUseCase loginUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
    required LogoutUseCase logoutUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _registerUseCase = registerUseCase,
        _loginUseCase = loginUseCase,
        _googleSignInUseCase = googleSignInUseCase,
        _logoutUseCase = logoutUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        super(const AuthInitial());

  Future<void> register({
    required String email,
    required String password,
    String? name,
    String? phone,
  }) async {
    emit(const AuthLoading());

    final registerResult = await _registerUseCase(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );

    await registerResult.fold(
      (error) async => emit(AuthError(error)),
      (user) async {
        final loginResult = await _loginUseCase(
          email: email,
          password: password,
        );

        loginResult.fold(
          (error) => emit(AuthError(error)),
          (authResult) => emit(AuthRegistrationSuccess(authResult.user)),
        );
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    final result = await _loginUseCase(
      email: email,
      password: password,
    );

    result.fold(
      (error) => emit(AuthError(error)),
      (authResult) => emit(AuthLoginSuccess(authResult.user)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());

    final result = await _googleSignInUseCase();

    result.fold(
      (error) => emit(AuthError(error)),
      (authResult) => emit(AuthGoogleSignInSuccess(authResult.user)),
    );
  }

  Future<void> logout() async {
    emit(const AuthLoading());

    final result = await _logoutUseCase();

    result.fold(
      (error) => emit(AuthError(error)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  void reset() {
    emit(const AuthInitial());
  }

  void clearError() {
    emit(const AuthUnauthenticated());
  }

  Future<void> forgotPassword({required String email}) async {
    emit(const AuthLoading());

    final result = await _forgotPasswordUseCase(email: email);

    result.fold(
      (error) => emit(AuthError(error)),
      (_) => emit(AuthOtpSent(email)),
    );
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(const AuthLoading());

    final result = await _verifyOtpUseCase(email: email, otp: otp);

    result.fold(
      (error) => emit(AuthError(error)),
      (_) => emit(AuthOtpVerified(email)),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(const AuthLoading());

    final result = await _resetPasswordUseCase(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );

    result.fold(
      (error) => emit(AuthError(error)),
      (_) => emit(const AuthPasswordResetSuccess()),
    );
  }
}
