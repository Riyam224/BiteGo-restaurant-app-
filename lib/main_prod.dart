import 'package:restaurant_app/core/config/flavor_config.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'main.dart' as app;

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.prod,
    appName: 'BiteGo',
    apiBaseUrl: 'https://api.bitego.com',
    splashBackgroundColor: AppColors.primary,
    enableLogging: false,
    enableAnalytics: true,
  );

  app.main();
}
