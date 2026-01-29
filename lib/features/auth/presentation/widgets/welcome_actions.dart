import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/core/common_ui/buttons/primary_button.dart';
import 'package:restaurant_app/core/common_ui/buttons/secondary_button.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_spacing.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class WelcomeActions extends StatelessWidget {
  final VoidCallback onCreateAccount;
  final VoidCallback onLogin;
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyPolicyTap;

  const WelcomeActions({
    super.key,
    required this.onCreateAccount,
    required this.onLogin,
    this.onTermsTap,
    this.onPrivacyPolicyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingH24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            text: AppStrings.createAccount,
            onPressed: onCreateAccount,
          ),
          AppSpacing.gapH16,
          SecondaryButton(
            text: AppStrings.login,
            onPressed: onLogin,
          ),
          AppSpacing.gapH20,
          _buildTermsAndPolicy(context),
          AppSpacing.gapH24,
        ],
      ),
    );
  }

  Widget _buildTermsAndPolicy(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: AppSpacing.paddingH12,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.bodyDescription.copyWith(
            color: isDark ? Colors.white70 : AppColors.textSecondary,
            height: 1.5,
          ),
          children: [
            TextSpan(text: AppStrings.termsPrefix),
            TextSpan(
              text: AppStrings.termsLinkText,
              style: AppTextStyles.bodyDescription.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = onTermsTap ?? () {},
            ),
            TextSpan(text: AppStrings.termsAnd),
            TextSpan(
              text: AppStrings.privacyPolicyText,
              style: AppTextStyles.bodyDescription.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = onPrivacyPolicyTap ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
