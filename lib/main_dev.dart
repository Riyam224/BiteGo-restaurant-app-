import 'package:restaurant_app/core/config/flavor_config.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';
import 'main.dart' as app;

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.dev,
    appName: 'BiteGo Dev',
    apiBaseUrl: 'https://dev-api.bitego.com',
    splashBackgroundColor: AppColors.secondary,
    enableLogging: true,
    enableAnalytics: false,
  );

  app.main();
}
