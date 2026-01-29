// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/routing/route_names.dart';
import 'package:restaurant_app/features/auth/presentation/screens/login_screen.dart';
import 'package:restaurant_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:restaurant_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:restaurant_app/features/splash/presentation/screens/splash_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class RouteGenerator {
  static final GoRouter mainRoutingInOurApp = GoRouter(
    navigatorKey: appNavigatorKey,
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Not found'))),
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, __) => const WelcomeScreen(),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
    ],
  );
}
