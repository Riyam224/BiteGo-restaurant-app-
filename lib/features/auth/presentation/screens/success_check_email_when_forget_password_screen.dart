import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_app/core/common_ui/buttons/primary_button.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_assets.dart';
import 'package:restaurant_app/core/constants/app_spacing.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class SuccessCheckEmailWhenForgetPasswordScreen extends StatelessWidget {
  const SuccessCheckEmailWhenForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppSpacing.gapH295,
            Lottie.asset(
              AppAssets.lottieCheck,
              width: AppSpacing.gapH140.height,
              height: AppSpacing.gapH140.height,
              fit: BoxFit.fill,
            ),
            AppSpacing.gapH8,
            Text(
              AppStrings.successTitle,
              style: AppTextStyles.headlineLarge.copyWith(
                color: theme.brightness == Brightness.dark
                    ? AppColors.textWhite
                    : AppColors.textPrimary,
              ),
            ),
            Padding(
              padding: AppSpacing.paddingH24,
              child: Text(
                AppStrings.checkEmailTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.successMessage.copyWith(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.textWhite
                      : AppColors.textSecondary,
                ),
              ),
            ),
            AppSpacing.gapH28,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.cantGetEmail,
                  style: AppTextStyles.authLinkBold.copyWith(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.textWhite
                        : AppColors.textSecondary,
                  ),
                ),
                AppSpacing.gapW4,
                Text(
                  AppStrings.resubmit,
                  style: AppTextStyles.authLinkBold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            AppSpacing.gapH120,
            Padding(
              padding: AppSpacing.paddingH24,
              child: PrimaryButton(
                text: AppStrings.backToEmail,
                onPressed: () {},
              ),
            ),
            AppSpacing.gapH70,
          ],
        ),
      ),
    );
  }
}
