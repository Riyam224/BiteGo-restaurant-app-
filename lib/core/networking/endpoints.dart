class ApiEndpoints {
  ApiEndpoints._();

  // =========================
  // BASE
  // =========================
  static const String baseUrl = '/api/v1';

  // Optional (documentation)
  static const String swagger = '/api/docs/';
  static const String schema = '/api/schema/';

  // =========================
  // AUTH
  // =========================
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String refreshToken = '$baseUrl/auth/refresh';

  // =========================
  // PROFILE (Bearer required)
  // =========================
  static const String profile = '$baseUrl/profile';

  // =========================
  // CATEGORIES (Public)
  // =========================
  static const String categories = '$baseUrl/categories/';

  // =========================
  // PRODUCTS / MENU (Public)
  // =========================
  static const String products = '$baseUrl/products/';

  static String productsByCategory(int categoryId) =>
      '$baseUrl/products/?category_id=$categoryId';

  static String productDetails(int productId) =>
      '$baseUrl/products/$productId/';

  // =========================
  // CART (Bearer required)
  // =========================
  static const String cart = '$baseUrl/cart/';

  static const String addToCart = '$baseUrl/cart/add/';

  static String removeCartItem(int itemId) => '$baseUrl/cart/item/$itemId/';

  // =========================
  // ORDERS (Bearer required)
  // =========================
  static const String createOrder = '$baseUrl/orders/create/';

  static const String orders = '$baseUrl/orders/';

  static String orderDetails(int orderId) => '$baseUrl/orders/$orderId/';

  // Admin only
  static String updateOrderStatus(int orderId) =>
      '$baseUrl/orders/$orderId/status/';
}
