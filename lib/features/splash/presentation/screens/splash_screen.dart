import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/core/config/animation_config.dart';
import 'package:restaurant_app/core/config/flavor_config.dart';
import 'package:restaurant_app/core/constants/hero_tags.dart';
import 'package:restaurant_app/core/routing/route_names.dart';
import 'package:restaurant_app/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: AnimationConfig.splashAnimationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: AnimationConfig.splashAnimationCurve,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.go(AppRoutes.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final appName = AppLocalizations.of(context)?.appName ?? 'BiteGo';

    return Scaffold(
      backgroundColor: FlavorConfig.instance.splashBackgroundColor,

      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: Tween(
              begin: AnimationConfig.splashScaleBegin,
              end: AnimationConfig.splashScaleEnd,
            ).animate(_animation),
            child: Hero(
              tag: HeroTags.appLogo,
              child: Text(
                appName,
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
