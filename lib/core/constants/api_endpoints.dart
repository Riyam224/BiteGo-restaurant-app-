import 'api_base.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // =========================
  // AUTH
  // =========================
  static const String register = '${ApiBase.apiV1}/auth/register';

  static const String login = '${ApiBase.apiV1}/auth/login';

  static const String refreshToken = '${ApiBase.apiV1}/auth/refresh';

  // =========================
  // PROFILE (Bearer required)
  // =========================
  static const String profile = '${ApiBase.apiV1}/profile';

  // =========================
  // CATEGORIES (Public)
  // =========================
  static const String categories = '${ApiBase.apiV1}/categories/';

  // =========================
  // PRODUCTS / MENU (Public)
  // =========================
  static const String products = '${ApiBase.apiV1}/products/';

  static String productsByCategory(int categoryId) =>
      '${ApiBase.apiV1}/products/?category_id=$categoryId';

  static String productDetails(int productId) =>
      '${ApiBase.apiV1}/products/$productId/';

  // =========================
  // CART (Bearer required)
  // =========================
  static const String cart = '${ApiBase.apiV1}/cart/';

  static const String addToCart = '${ApiBase.apiV1}/cart/add/';

  static String removeCartItem(int itemId) =>
      '${ApiBase.apiV1}/cart/item/$itemId/';

  // =========================
  // ORDERS (Bearer required)
  // =========================
  static const String createOrder = '${ApiBase.apiV1}/orders/create/';

  static const String orders = '${ApiBase.apiV1}/orders/';

  static String orderDetails(int orderId) =>
      '${ApiBase.apiV1}/orders/$orderId/';

  /// Admin only
  static String updateOrderStatus(int orderId) =>
      '${ApiBase.apiV1}/orders/$orderId/status/';
}
