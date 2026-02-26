import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/models/product_model.dart';
import 'package:restaurant_app/core/routing/route_names.dart';
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

  /// Converts NewArrivalModel to ProductModel for navigation
  ProductModel _convertNewArrivalToProduct(NewArrivalModel item) {
    return ProductModel(
      id: item.id,
      name: item.name,
      description: 'Delicious ${item.name} from our ${item.restaurantName} collection. Order now and enjoy!',
      price: 15.99, // Default price for demo
      imageUrl: item.imageUrl,
      category: item.restaurantName,
      rating: item.rating ?? 0.0,
      reviewCount: item.reviewCount,
      isAvailable: true,
      tags: ['Popular', 'New Arrival'],
    );
  }

  /// Converts RestaurantModel to ProductModel for navigation
  ProductModel _convertRestaurantToProduct(RestaurantModel item) {
    // Extract price from address if available (format: "description\n$XX.XX")
    final parts = item.address.split('\n');
    final priceString = parts.length > 1 ? parts[1].replaceAll('\$', '') : '0';
    final price = double.tryParse(priceString) ?? 0.0;
    final description = parts.isNotEmpty ? parts[0] : item.name;

    return ProductModel(
      id: item.id,
      name: item.name,
      description: description,
      price: price,
      imageUrl: item.imageUrl,
      category: 'Popular Menu',
      rating: 4.5,
      reviewCount: 25,
      isAvailable: true,
      tags: ['Popular', 'Recommended'],
    );
  }

  // Sample data for today's specials
  List<NewArrivalModel> get _todaysSpecials => [
    NewArrivalModel(
      id: '1',
      name: 'Chicken Biryani',
      restaurantName: 'Main Course',
      imageUrl:
          'https://images.pexels.com/photos/20642812/pexels-photo-20642812.jpeg',
      reviewCount: 62,
      rating: 4.5,
    ),
    NewArrivalModel(
      id: '2',
      name: 'Margherita Pizza',
      restaurantName: 'Italian',
      imageUrl:
          'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg',
      reviewCount: 48,
      rating: 4.7,
    ),
    NewArrivalModel(
      id: '3',
      name: 'Beef Burger',
      restaurantName: 'Fast Food',
      imageUrl:
          'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg',
      reviewCount: 35,
      rating: 4.3,
    ),
    NewArrivalModel(
      id: '4',
      name: 'Pasta Carbonara',
      restaurantName: 'Italian',
      imageUrl:
          'https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg',
      reviewCount: 28,
      rating: 4.6,
    ),
  ];

  // Sample data for popular menu items
  List<RestaurantModel> get _popularMenuItems => [
    RestaurantModel(
      id: '1',
      name: 'Grilled Salmon',
      address: 'Fresh Atlantic salmon with herbs\n\$24.99',
      imageUrl:
          'https://images.pexels.com/photos/1516415/pexels-photo-1516415.jpeg',
    ),
    RestaurantModel(
      id: '2',
      name: 'Caesar Salad',
      address: 'Classic Caesar with homemade dressing\n\$12.99',
      imageUrl:
          'https://images.pexels.com/photos/1059905/pexels-photo-1059905.jpeg',
    ),
    RestaurantModel(
      id: '3',
      name: 'Chocolate Lava Cake',
      address: 'Warm chocolate cake with ice cream\n\$8.99',
      imageUrl:
          'https://images.pexels.com/photos/291528/pexels-photo-291528.jpeg',
    ),
    RestaurantModel(
      id: '4',
      name: 'Sushi Platter',
      address: 'Assorted fresh sushi rolls\n\$32.99',
      imageUrl:
          'https://images.pexels.com/photos/357756/pexels-photo-357756.jpeg',
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

                  // Today's Specials Horizontal List
                  SizedBox(
                    height: 280.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _todaysSpecials.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final item = _todaysSpecials[index];
                        return NewArrivalCard(
                          item: item,
                          onTap: () {
                            // Convert to ProductModel and navigate to details
                            final product = _convertNewArrivalToProduct(item);
                            context.push(AppRoutes.productDetails, extra: product);
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 38.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTitle(title: 'Popular Menu'),
                      SeeAllWithIcon(),
                    ],
                  ),
                  CustomSubtitle(text: 'Most ordered dishes this week'),
                  SizedBox(height: 16.h),

                  // Popular Menu Items List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _popularMenuItems.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final menuItem = _popularMenuItems[index];
                      return BookingRestaurantCard(
                        restaurantName: menuItem.name,
                        address: menuItem.address,
                        imageUrl: menuItem.imageUrl,
                        onTap: () {
                          // Navigate to product details when card is tapped
                          final product = _convertRestaurantToProduct(menuItem);
                          context.push(AppRoutes.productDetails, extra: product);
                        },
                        onBookPressed: () {
                          // Navigate to product details when "Try it" button is pressed
                          final product = _convertRestaurantToProduct(menuItem);
                          context.push(AppRoutes.productDetails, extra: product);
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
