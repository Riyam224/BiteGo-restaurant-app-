import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_password_field.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_text_field.dart';
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
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Handle forgot password
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 36.h),
        AuthButton(
          text: 'Login',
          onPressed: () {
            // Handle login
          },
        ),
        SizedBox(height: 16.h),
        GoogleSignInButton(
          text: 'Login with Google',
          onPressed: () {
            // Handle Google login
          },
        ),
      ],
    );
  }
}
