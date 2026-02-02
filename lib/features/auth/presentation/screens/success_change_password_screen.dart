import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_app/core/common_ui/buttons/primary_button.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_assets.dart';
import 'package:restaurant_app/core/constants/app_spacing.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class SuccessChangePasswordScreen extends StatelessWidget {
  const SuccessChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
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
                  AppStrings.passwordChangedMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.successMessage.copyWith(
                    color: theme.brightness == Brightness.dark
                        ? AppColors.textWhite
                        : AppColors.textSecondary,
                  ),
                ),
              ),

              AppSpacing.gapH200,
              Padding(
                padding: AppSpacing.paddingH24,
                child: PrimaryButton(text: AppStrings.signIn, onPressed: () {}),
              ),
              AppSpacing.gapH70,
            ],
          ),
        ),
      ),
    );
  }
}
