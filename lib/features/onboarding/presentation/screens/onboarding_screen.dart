import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_strings.dart';
import 'package:restaurant_app/core/routing/route_names.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/core/constants/app_spacing.dart';
import 'package:restaurant_app/core/constants/app_sizing.dart';
import 'package:restaurant_app/core/config/animation_config.dart';
import '../../data/constants/onboarding_constants.dart';
import '../../data/models/onboarding_model.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_page_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _onboardingPages = onboardingData;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToNextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: AnimationConfig.onboardingPageTransition,
        curve: AnimationConfig.standardCurve,
      );
    } else {
      GoRouter.of(context).go(AppRoutes.welcome);
    }
  }

  void _skipOnboarding() {
    GoRouter.of(context).go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingPages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageItem(content: _onboardingPages[index]);
                },
              ),
            ),
            Padding(
              padding: AppSpacing.symmetricPadding(
                horizontal: OnboardingConstants.bottomNavPaddingHorizontal,
                vertical: OnboardingConstants.bottomNavPaddingVertical,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      AppStrings.skip,
                      style: AppTextStyles.restaurantSubtitle.copyWith(
                        fontSize: OnboardingConstants.skipButtonFontSize,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),

                  // Page indicator
                  OnboardingPageIndicator(
                    currentPage: _currentPage,
                    pageCount: _onboardingPages.length,
                  ),

                  // Next button
                  InkWell(
                    onTap: _navigateToNextPage,
                    borderRadius: BorderRadius.circular(AppSizing.radius22),
                    child: Container(
                      width: AppSizing.w48,
                      height: AppSizing.w48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.textWhite,
                        size: AppSizing.iconSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
