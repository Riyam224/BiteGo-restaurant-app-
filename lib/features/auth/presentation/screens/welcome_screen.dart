

// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant_app/core/common_ui/buttons/primary_button.dart';
import 'package:restaurant_app/core/common_ui/buttons/secondary_button.dart';
import 'package:restaurant_app/core/constants/app_assets.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/authBottomSheet.dart';

enum AuthType { login, register }

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 120),
              SvgPicture.asset(AppAssets.welcome),
              const SizedBox(height: 55),
              const Text(
                'Welcome',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Before enjoying food services\nplease register first',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 95),

              /// Create Account
              PrimaryButton(
                text: AppStrings.createAccount,
                onPressed: () {
                  _showAuthBottomSheet(context, authType: AuthType.register);
                },
              ),
              const SizedBox(height: 16),

              /// Login
              SecondaryButton(
                text: AppStrings.login,
                onPressed: () {
                  _showAuthBottomSheet(context, authType: AuthType.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAuthBottomSheet(
    BuildContext context, {
    required AuthType authType,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AuthBottomSheet(authType: authType);
      },
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _SecondaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
