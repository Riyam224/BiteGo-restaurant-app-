class ApiEndpoints {
  ApiEndpoints._();

  // =========================
  // AUTH
  // =========================
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';

  // Password Recovery
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  // =========================
  // PROFILE
  // =========================
  static const String profile = '/profile';

  // =========================
  // ADDRESSES
  // =========================
  static const String addresses = '/addresses';

  static String addressDetails(int id) => '/addresses/$id';

  // =========================
  // CATEGORIES
  // =========================
  static const String categories = '/categories';

  // =========================
  // PRODUCTS
  // =========================
  static const String products = '/products';

  static String productsByCategory(int categoryId) =>
      '/products/?category_id=$categoryId';

  static String productDetails(int id) => '/products/$id';

  // =========================
  // CART
  // =========================
  static const String cart = '/cart';
  static const String addToCart = '/cart/add';

  static String removeCartItem(int id) => '/cart/item/$id';

  // =========================
  // ORDERS
  // =========================
  static const String orders = '/orders';
  static const String createOrder = '/orders/create';

  static String orderDetails(int id) => '/orders/$id';
  static String orderStatus(int id) => '/orders/$id/status';

  // =========================
  // REVIEWS
  // =========================
  static const String reviews = '/reviews';
  static const String myReviews = '/reviews/my';
  static const String createReview = '/reviews/create';

  static String reviewDetails(int id) => '/reviews/$id';
  static String updateReview(int id) => '/reviews/$id';
  static String deleteReview(int id) => '/reviews/$id';
}
