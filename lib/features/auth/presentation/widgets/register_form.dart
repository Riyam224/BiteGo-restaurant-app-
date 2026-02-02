import 'package:flutter/material.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_password_field.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_text_field.dart';
import 'package:restaurant_app/core/constants/app_spacing.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/auth_button.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/google_sign_in_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _nameController,
          label: AppStrings.fullName,
          hintText: AppStrings.exampleFullName,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.fullNameRequired;
            }
            return null;
          },
        ),
        AppSpacing.gapH16,
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
        AppSpacing.gapH33,
        AuthButton(
          text: AppStrings.registration,
          onPressed: () {
            // Handle registration
          },
        ),
        AppSpacing.gapH16,
        GoogleSignInButton(
          text: AppStrings.signUpWithGoogle,
          onPressed: () {
            // Handle Google sign up
          },
        ),
      ],
    );
  }
}
