import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_password_field.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_text_field.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_spacing.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/routing/route_names.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/google_sign_in_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _emailController,
          label: AppStrings.email,
          hintText: AppStrings.exampleEmail,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.emailRequired;
            }
            return null;
          },
        ),
        AppSpacing.gapH16,
        CustomPasswordField(
          controller: _passwordController,
          label: AppStrings.password,
          hintText: AppStrings.examplePassword,
          validator: (value) {
            if (value == null || value.length < 6) {
              return AppStrings.passwordTooShort;
            }
            return null;
          },
        ),
        AppSpacing.gapH8,
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              GoRouter.of(context).go(AppRoutes.forgetPassword);
            },
            child: Text(
              AppStrings.forgotPassword,
              style: AppTextStyles.authLink.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        AppSpacing.gapH33,
        AuthButton(
          text: AppStrings.login,
          onPressed: () {
            // Handle login
          },
        ),
        AppSpacing.gapH16,
        GoogleSignInButton(
          text: AppStrings.loginWithGoogle,
          onPressed: () {
            // Handle Google login
          },
        ),
      ],
    );
  }
}
