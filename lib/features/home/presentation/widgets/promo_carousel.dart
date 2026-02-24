import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/constants/app_assets.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'package:restaurant_app/features/home/data/models/promo_model.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  late final PageController _controller;
  int currentIndex = 0;

  final promos = [
    PromoModel(
      title: "Flash Offer",
      subtitle: "We are here with the best\ndesserts ever!",
      image: AppAssets.burgerCarousel,
      gradientColors: const [AppColors.promoOrangeLight, AppColors.promoOrangeMedium],
    ),
    PromoModel(
      title: "New Arrival",
      subtitle: "Try our special pizza today!",
      image: AppAssets.pizzaCarousel,
      gradientColors: const [AppColors.promoGreenLight, AppColors.promoGreenMedium],
    ),
    PromoModel(
      title: "Special Deal",
      subtitle: "Get 50% off on all\nitems today!",
      image: AppAssets.friedCarousel,
      gradientColors: const [AppColors.promoRedLight, AppColors.promoRedMedium],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.h,
          width: 1000.w,
          child: PageView.builder(
            controller: _controller,
            itemCount: promos.length,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemBuilder: (context, index) {
              return _PromoCard(
                promo: promos[index],
                pageController: _controller,
                index: index,
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            promos.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 8.h,
              width: currentIndex == index ? 24.w : 8.w,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  final PromoModel promo;
  final PageController pageController;
  final int index;

  const _PromoCard({
    required this.promo,
    required this.pageController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double scale = 1.0;
        double opacity = 1.0;

        if (pageController.position.haveDimensions) {
          final value = index - (pageController.page ?? 0);
          scale = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
          opacity = (1 - (value.abs() * 0.4)).clamp(0.6, 1.0);
        }

        return Center(
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: child,
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: promo.gradientColors,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: promo.gradientColors.first.withOpacity(0.3),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        promo.title,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        promo.subtitle,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white.withOpacity(0.95),
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          "Order Now",
                          style: TextStyle(
                            color: promo.gradientColors.first,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 5,
                  child: AnimatedBuilder(
                    animation: pageController,
                    builder: (context, child) {
                      double offsetX = 0.0;

                      if (pageController.position.haveDimensions) {
                        final value = index - (pageController.page ?? 0);
                        offsetX = (value * 15).clamp(-15.0, 15.0).toDouble();
                      }

                      return Transform.translate(
                        offset: Offset(offsetX, 0),
                        child: child,
                      );
                    },
                    child: Image.asset(promo.image, fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
