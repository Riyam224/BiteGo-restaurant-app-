import 'package:restaurant_app/core/constants/app_assets.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

// todo onboarding data

List<OnboardingModel> onboardingData = [
  OnboardingModel(
    image: AppAssets.onboarding1,
    title: 'Nearby restaurants',
    description:
        'You don\'t have to go far to find a good restaurant,\nwe have provided all the restaurants that is \nnear you',
  ),
  OnboardingModel(
    image: AppAssets.onboarding2,
    title: 'Select the Favorites Menu',
    description:
        'Now eat well, don\'t leave the house,You can \nchoose your favorite food only with \none click',
  ),
  OnboardingModel(
    image: AppAssets.onboarding3,
    title: 'Good food at a cheap price',
    description: 'You can eat at expensive restaurants with affordable price',
  ),
];
