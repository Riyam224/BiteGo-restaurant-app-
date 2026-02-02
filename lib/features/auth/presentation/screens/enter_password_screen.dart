import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/common_ui/buttons/primary_button.dart';
import 'package:restaurant_app/core/common_ui/buttons/secondary_button.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_password_field.dart';

import '../../../../core/config/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/app_colors.dart';

class EnterPassword extends StatefulWidget {
  const EnterPassword({super.key});

  @override
  State<EnterPassword> createState() => _EnterPasswordState();
}

class _EnterPasswordState extends State<EnterPassword> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_onFieldsChanged);
    _confirmPasswordController.addListener(_onFieldsChanged);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_onFieldsChanged);
    _confirmPasswordController.removeListener(_onFieldsChanged);
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onFieldsChanged() {
    setState(() {
      _isFormFilled =
          _newPasswordController.text.trim().isNotEmpty &&
          _confirmPasswordController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppSpacing.paddingH24T120,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.changeNewPasswordTitle,
                    style: AppTextStyles.forgetPasswordTitle.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.gapH4,
                  Text(
                    AppStrings.changeNewPasswordSubtitle,
                    style: AppTextStyles.bodyMedium,
                  ),
                  AppSpacing.gapH55,
                  CustomPasswordField(
                    label: AppStrings.newPassword,
                    controller: _newPasswordController,
                    hintText: AppStrings.enterNewPassword,
                  ),
                  AppSpacing.gapH24,
                  CustomPasswordField(
                    label: AppStrings.confirmPassword,
                    controller: _confirmPasswordController,
                    hintText: AppStrings.reEnterPassword,
                  ),
                ],
              ),
              AppSpacing.gapH270,
              _isFormFilled
                  ? PrimaryButton(
                      text: AppStrings.resetPassword,
                      onPressed: () {
                        // Handle password reset
                        GoRouter.of(
                          context,
                        ).go(AppRoutes.successCheckEmailWhenForgetPassword);
                      },
                    )
                  : SecondaryButton(
                      text: AppStrings.resetPassword,
                      textColor: AppColors.textDisabled,
                      backgroundColor: AppColors.backgroundSoft,
                      onPressed: () {
                        // Button is disabled when empty
                        GoRouter.of(
                          context,
                        ).go(AppRoutes.successChangePassword);
                      },
                    ),
              AppSpacing.gapH70,
            ],
          ),
        ),
      ),
    );
  }
}
