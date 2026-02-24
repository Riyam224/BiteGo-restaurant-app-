import 'dart:ui';

class PromoModel {
  final String title;
  final String subtitle;
  final String image;
  
  final List<Color> gradientColors;

  PromoModel({
    required this.title,
    required this.subtitle,
    required this.image,
   
    required this.gradientColors,
  });
}
