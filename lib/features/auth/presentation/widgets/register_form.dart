import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_password_field.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_text_field.dart';
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
          label: 'Full Name',
          hintText: 'Eg Jhon Doe',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Full name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          label: 'Email address',
          hintText: 'Eg namaemail@emailkamu.com',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomPasswordField(
          controller: _passwordController,
          label: 'Password',
          hintText: '**********',
          validator: (value) {
            if (value == null || value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 36.h),
        AuthButton(
          text: 'Registration',
          onPressed: () {
            // Handle registration
          },
        ),
        SizedBox(height: 16.h),
        GoogleSignInButton(
          text: 'Sign up with Google',
          onPressed: () {
            // Handle Google sign up
          },
        ),
      ],
    );
  }
}
