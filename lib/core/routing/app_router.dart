// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/routing/route_names.dart';
import 'package:restaurant_app/features/auth/presentation/screens/success_check_email_when_forget_password_screen.dart';

import 'package:restaurant_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:restaurant_app/features/main/presentation/screens/main_screen.dart';
import 'package:restaurant_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:restaurant_app/features/splash/presentation/screens/splash_screen.dart';

import '../../features/auth/presentation/screens/enter_password_screen.dart';
import '../../features/auth/presentation/screens/forget_password_screen.dart';
import '../../features/auth/presentation/screens/success_change_password_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/coupons/presentation/screens/coupons_screen.dart';
import '../../features/addresses/presentation/screens/addresses_screen.dart';
import '../../features/reviews/presentation/screens/reviews_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/map/presentation/screens/order_tracking_map_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/products/presentation/screens/category_products_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../core/models/product_model.dart';
import '../../core/models/category_model.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class RouteGenerator {
  static final GoRouter mainRoutingInOurApp = GoRouter(
    navigatorKey: appNavigatorKey,
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Not found'))),
    initialLocation: AppRoutes.home,
    routes: [
      // splash screen route
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      // onboarding screen route
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      // Auth routes
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, __) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgetPassword,
        builder: (_, __) => const ForgetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.successCheckEmailWhenForgetPassword,
        builder: (_, __) => const SuccessCheckEmailWhenForgetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.enterPassword,
        builder: (_, __) => const EnterPassword(),
      ),
      GoRoute(
        path: AppRoutes.successChangePassword,
        builder: (_, __) => const SuccessChangePasswordScreen(),
      ),
      // home route with fade transition
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
              child: child,
            );
          },
        ),
      ),
      // Feature routes
      GoRoute(
        path: AppRoutes.categories,
        builder: (_, __) => const CategoriesScreen(),
      ),
      GoRoute(
        path: AppRoutes.coupons,
        builder: (_, __) => const CouponsScreen(),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        builder: (_, __) => const AddressesScreen(),
      ),
      GoRoute(
        path: AppRoutes.reviews,
        builder: (_, __) => const ReviewsScreen(),
      ),
      GoRoute(
        path: AppRoutes.inventory,
        builder: (_, __) => const InventoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderTracking,
        builder: (_, __) => const OrderTrackingMapScreen(),
      ),
      // Product routes
      GoRoute(
        path: AppRoutes.productDetails,
        builder: (context, state) {
          final product = state.extra as ProductModel?;
          if (product == null) {
            // If no product is passed, navigate back to home
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(AppRoutes.home);
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return ProductDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: AppRoutes.categoryProducts,
        builder: (context, state) {
          final category = state.extra as CategoryModel;
          return CategoryProductsScreen(category: category);
        },
      ),
      // Checkout route
      GoRoute(
        path: AppRoutes.checkout,
        builder: (_, __) => const CheckoutScreen(),
      ),
    ],
  );
}
