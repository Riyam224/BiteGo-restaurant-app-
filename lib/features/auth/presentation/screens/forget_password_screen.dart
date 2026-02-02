import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/common_ui/buttons/primary_button.dart';
import 'package:restaurant_app/core/common_ui/buttons/secondary_button.dart';
import 'package:restaurant_app/core/common_ui/inputs/custom_text_field.dart';

import '../../../../core/config/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/app_colors.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isEmailFilled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    setState(() {
      _isEmailFilled = _emailController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: AppSpacing.paddingOnly(left: 24, right: 24, top: 120),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.forgetPasswordTitle,
                    style: AppTextStyles.forgetPasswordTitle.copyWith(
                      color: theme.brightness == Brightness.dark
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                    ),
                  ),
                  AppSpacing.gapH4,
                  Text(
                    AppStrings.forgetPasswordSubtitle,
                    style: AppTextStyles.forgetPasswordSubtitle.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.gapH55,
                  CustomTextField(
                    label: AppStrings.emailAddress,
                    controller: _emailController,
                    hintText: AppStrings.enterYourEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.emailRequired;
                      }
                      return null;
                    },
                  ),
                  AppSpacing.gapH16,
                  Row(
                    children: [
                      Text(
                        AppStrings.rememberPassword,
                        style: AppTextStyles.authLink.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.gapW4,
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).go(AppRoutes.welcome);
                        },
                        child: Text(
                          AppStrings.signIn,
                          style: AppTextStyles.authLink.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacing.customGapH(344),
              _isEmailFilled
                  ? PrimaryButton(
                      text: AppStrings.submit,
                      onPressed: () {
                        // Handle submit
                        GoRouter.of(
                          context,
                        ).go(AppRoutes.successCheckEmailWhenForgetPassword);
                      },
                    )
                  : SecondaryButton(
                      text: AppStrings.submit,
                      textColor: AppColors.textDisabled,
                      backgroundColor: AppColors.backgroundSoft,
                      onPressed: () {
                        // Button is disabled when empty
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
