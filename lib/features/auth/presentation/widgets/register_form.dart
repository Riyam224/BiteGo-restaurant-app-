import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/common_ui/dialogs/success_dialog.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_password_field.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_text_field.dart';
import 'package:restaurant_app/core/config/timing_config.dart';
import 'package:restaurant_app/core/constants/app_spacing.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/routing/route_names.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/core/utils/app_logger.dart';
import 'package:restaurant_app/features/auth/domain/validators/auth_validator.dart';
import 'package:restaurant_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:restaurant_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/google_sign_in_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final name = _nameController.text.trim();
      AppLogger.auth('Registration attempt for: $email (Name: $name)');

      context.read<AuthCubit>().register(
            email: email,
            password: _passwordController.text,
            name: name,
          );
    } else {
      AppLogger.warning('Registration form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          AppLogger.error('Registration failed: ${state.message}');

          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              duration: TimingConfig.snackbarErrorDuration,
            ),
          );
        } else if (state is AuthRegistrationSuccess) {
          AppLogger.auth('Registration successful for: ${state.user.email}');

          if (!context.mounted) return;

          Navigator.of(context).pop();

          final router = GoRouter.of(context);

          SuccessDialog.show(
            context,
            title: AppStrings.welcomeAboardTitle,
            message: AppStrings.registrationSuccessMessage,
            autoCloseDuration: TimingConfig.mediumDelay,
            onComplete: () {
              AppLogger.navigation('Navigating to home screen');
              router.go(AppRoutes.home);
            },
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                label: AppStrings.fullName,
                hintText: AppStrings.exampleFullName,
                keyboardType: TextInputType.name,
                enabled: !isLoading,
                validator: AuthValidator.validateName,
              ),
              AppSpacing.gapH16,
              CustomTextField(
                controller: _emailController,
                label: AppStrings.email,
                hintText: AppStrings.exampleEmail,
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading,
                validator: AuthValidator.validateEmail,
              ),
              AppSpacing.gapH16,
              CustomPasswordField(
                controller: _passwordController,
                label: AppStrings.password,
                hintText: AppStrings.examplePassword,
                enabled: !isLoading,
                validator: AuthValidator.validatePassword,
              ),
              AppSpacing.gapH33,
              AuthButton(
                text: AppStrings.registration,
                onPressed: isLoading ? null : _handleRegister,
                isLoading: isLoading,
              ),
              AppSpacing.gapH16,
              GoogleSignInButton(
                text: AppStrings.signUpWithGoogle,
                onPressed: isLoading ? null : () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
