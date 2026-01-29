import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_spacing.dart';
import 'package:restaurant_app/core/constants/app_sizing.dart';

import '../../data/constants/onboarding_constants.dart';
import '../../data/models/onboarding_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel content;

  const OnboardingPageItem({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingH24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: OnboardingConstants.contentTopFlex),

          // Image
          SvgPicture.asset(
            content.image,
            height: AppSizing.h360,
            fit: BoxFit.contain,
          ),

          AppSpacing.customGapH(60),

          // Title
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.displayTitle.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),

          AppSpacing.gapH16,

          // Description
          Padding(
            padding: AppSpacing.paddingH20,
            child: Text(
              content.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyDescription.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),

          const Spacer(flex: OnboardingConstants.contentBottomFlex),
        ],
      ),
    );
  }
}
