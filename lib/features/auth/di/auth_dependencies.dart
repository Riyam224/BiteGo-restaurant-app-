import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:restaurant_app/features/auth/data/services/auth_service.dart';
import 'package:restaurant_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurant_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:restaurant_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:restaurant_app/features/auth/presentation/cubit/auth_cubit.dart';

class AuthDependencies {
  AuthDependencies._();

  static AuthService _authService() => AuthService();

  static AuthRepository _authRepository() => AuthRepositoryImpl(_authService());

  static RegisterUseCase _registerUseCase() =>
      RegisterUseCase(_authRepository());

  static LoginUseCase _loginUseCase() => LoginUseCase(_authRepository());

  static LogoutUseCase _logoutUseCase() => LogoutUseCase(_authRepository());

  static ForgotPasswordUseCase _forgotPasswordUseCase() =>
      ForgotPasswordUseCase(_authRepository());

  static VerifyOtpUseCase _verifyOtpUseCase() =>
      VerifyOtpUseCase(_authRepository());

  static ResetPasswordUseCase _resetPasswordUseCase() =>
      ResetPasswordUseCase(_authRepository());

  static AuthCubit _authCubit() => AuthCubit(
        registerUseCase: _registerUseCase(),
        loginUseCase: _loginUseCase(),
        logoutUseCase: _logoutUseCase(),
        forgotPasswordUseCase: _forgotPasswordUseCase(),
        verifyOtpUseCase: _verifyOtpUseCase(),
        resetPasswordUseCase: _resetPasswordUseCase(),
      );

  static List<BlocProvider> get providers => [
        BlocProvider<AuthCubit>(create: (_) => _authCubit()),
      ];

  static BlocProvider<AuthCubit> authCubitProvider() {
    return BlocProvider<AuthCubit>(create: (_) => _authCubit());
  }

  static AuthCubit createAuthCubit() => _authCubit();
}
