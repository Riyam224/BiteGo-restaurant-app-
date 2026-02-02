
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant_app/core/common_ui/buttons/primary_button.dart';
import 'package:restaurant_app/core/common_ui/buttons/secondary_button.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_assets.dart';
import 'package:restaurant_app/core/constants/app_spacing.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/authBottomSheet.dart';

enum AuthType { login, register }

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingH24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppSpacing.gapH120,
              SvgPicture.asset(AppAssets.welcome),
              AppSpacing.gapH55,
              Text(
                AppStrings.welcomeTitle,
                style: AppTextStyles.welcomeTitle.copyWith(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.textWhite
                      : AppColors.textPrimary,
                ),
              ),
              AppSpacing.gapH8,
              Text(
                AppStrings.welcomeSubtitle,
                style: AppTextStyles.welcomeDescription.copyWith(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.textWhite
                      : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapH95,

              /// Create Account
              PrimaryButton(
                text: AppStrings.createAccount,
                onPressed: () {
                  _showAuthBottomSheet(context, authType: AuthType.register);
                },
              ),
              AppSpacing.gapH16,

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
