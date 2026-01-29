import 'package:flutter/material.dart';
import 'package:restaurant_app/features/auth/data/constants/welcome_constants.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/welcome_actions.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/welcome_content.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/welcome_illustration.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: WelcomeConstants.topSpacerFlex),
            const WelcomeIllustration(),
            const Spacer(flex: WelcomeConstants.middleSpacerFlex),
            const WelcomeContent(),
            const Spacer(flex: WelcomeConstants.bottomSpacerFlex),
            WelcomeActions(
              onCreateAccount: () => _handleCreateAccount(context),
              onLogin: () => _handleLogin(context),
              onTermsTap: () => _handleTermsTap(context),
              onPrivacyPolicyTap: () => _handlePrivacyPolicyTap(context),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCreateAccount(BuildContext context) {
    // TODO: Navigate to register screen
  }

  void _handleLogin(BuildContext context) {
    // TODO: Navigate to login screen
  }

  void _handleTermsTap(BuildContext context) {
    // TODO: Navigate to terms and conditions
  }

  void _handlePrivacyPolicyTap(BuildContext context) {
    // TODO: Navigate to privacy policy
  }
}
