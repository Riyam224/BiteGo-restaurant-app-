import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restaurant_app/features/home/data/models/new_arrival_model.dart';
import 'package:restaurant_app/features/home/data/models/restaurant_model.dart';
import 'package:restaurant_app/features/home/presentation/widgets/booking_restaurant_card.dart';
import 'package:restaurant_app/features/home/presentation/widgets/custom_subtitle.dart';
import 'package:restaurant_app/features/home/presentation/widgets/custom_title.dart';
import 'package:restaurant_app/features/home/presentation/widgets/new_arrival_card.dart';
import 'package:restaurant_app/features/home/presentation/widgets/see_all_with_icon.dart';

import '../../../../core/common_ui/widgets/custom_text_field.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_colors.dart';
import '../widgets/promo_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sample data for new arrivals
  List<NewArrivalModel> get _newArrivals => [
    NewArrivalModel(
      id: '1',
      name: 'Chicken Biryani',
      restaurantName: 'Ambrosia Hotel & Restaurant',
      imageUrl:
          'https://images.pexels.com/photos/20642812/pexels-photo-20642812.jpeg',
      reviewCount: 62,
      rating: 4.5,
    ),
    NewArrivalModel(
      id: '2',
      name: 'Margherita Pizza',
      restaurantName: 'Pizza Palace',
      imageUrl:
          'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg',
      reviewCount: 48,
      rating: 4.7,
    ),
    NewArrivalModel(
      id: '3',
      name: 'Beef Burger',
      restaurantName: 'Burger House',
      imageUrl:
          'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg',
      reviewCount: 35,
      rating: 4.3,
    ),
  ];

  // Sample data for booking restaurants
  List<RestaurantModel> get _bookingRestaurants => [
    RestaurantModel(
      id: '1',
      name: 'Ambrosia Hotel & Restaurant',
      address: 'Kazi Deiry, Taiger Pass\nChittagong',
      imageUrl:
          'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg',
    ),
    RestaurantModel(
      id: '2',
      name: 'Tava Restaurant',
      address: 'Zakir Hossain Rd,\nChittagong',
      imageUrl:
          'https://images.pexels.com/photos/941861/pexels-photo-941861.jpeg',
    ),
    RestaurantModel(
      id: '3',
      name: 'Haatkhola',
      address: '6 Surson Road,\nChittagong',
      imageUrl:
          'https://images.pexels.com/photos/3201921/pexels-photo-3201921.jpeg',
    ),
    RestaurantModel(
      id: '4',
      name: 'Spice Garden',
      address: 'Agrabad Commercial Area,\nChittagong',
      imageUrl:
          'https://images.pexels.com/photos/1581384/pexels-photo-1581384.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header with sticky search field
          SliverAppBar(
            backgroundColor: AppColors.getBackground(context),
            elevation: 0,
            pinned: true,
            floating: false,
            expandedHeight: 160.h,
            toolbarHeight: 90.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 60.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          AppAssets.menuIcon,
                          width: 24.w,
                          height: 24.w,
                          colorFilter: ColorFilter.mode(
                            AppColors.getIcon(context),
                            BlendMode.srcIn,
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.mapIcon,
                              width: 16.w,
                              height: 16.w,
                              colorFilter: ColorFilter.mode(
                                AppColors.getIcon(context),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Agrabad 435, Chittagong',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.getTextSecondary(context),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: ShapeDecoration(
                            image: const DecorationImage(
                              image: AssetImage(AppAssets.profileGirl),
                              fit: BoxFit.cover,
                            ),
                            shape: const OvalBorder(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(70.h),
              child: Container(
                color: AppColors.getBackground(context),
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 16.h),
                child: const CustomTextField(
                  hintText: AppStrings.searchFoodOrRestaurant,
                ),
              ),
            ),
          ),

          // Scrollable Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Promo Carousel
                  const PromoCarousel(),

                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTitle(title: AppStrings.todayNewArrivals),
                      SeeAllWithIcon(),
                    ],
                  ),
                  CustomSubtitle(text: AppStrings.bestOfTodayFoodList),
                  SizedBox(height: 16.h),

                  // New Arrivals Horizontal List
                  SizedBox(
                    height: 280.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _newArrivals.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return NewArrivalCard(
                          item: _newArrivals[index],
                          onTap: () {
                            // Handle card tap - navigate to detail page
                            debugPrint('Tapped on: ${_newArrivals[index].name}');
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 38.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTitle(title: AppStrings.exploreRestaurant),
                      SeeAllWithIcon(),
                    ],
                  ),
                  CustomSubtitle(text: AppStrings.checkCityNearbyRestaurant),
                  SizedBox(height: 16.h),

                  // Booking Restaurants List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _bookingRestaurants.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final restaurant = _bookingRestaurants[index];
                      return BookingRestaurantCard(
                        restaurantName: restaurant.name,
                        address: restaurant.address,
                        imageUrl: restaurant.imageUrl,
                        onBookPressed: () {
                          // Handle booking action
                          debugPrint('Book ${restaurant.name}');
                        },
                      );
                    },
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
