/// API Endpoints for the Restaurant App
/// Base URL: https://web-production-e1bea.up.railway.app/api/v1
///
/// Documentation: https://web-production-e1bea.up.railway.app/api/docs/
/// See also: docs/API_REFERENCE.md
class ApiEndpoints {
  ApiEndpoints._();

  // =========================
  // AUTH (PUBLIC - PublicApiService)
  // =========================
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String googleSignIn = '/auth/google';

  // Password Recovery Flow
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  // =========================
  // PROFILE (PROTECTED - BaseApiService)
  // =========================
  static const String profile = '/profile';

  // =========================
  // ADDRESSES (PROTECTED - BaseApiService)
  // =========================
  static const String addresses = '/addresses';
  static String addressDetails(int id) => '/addresses/$id';

  // =========================
  // CATEGORIES (PUBLIC)
  // =========================
  static const String categories = '/categories';

  // =========================
  // PRODUCTS (PUBLIC)
  // =========================
  static const String products = '/products';
  static String productDetails(int id) => '/products/$id';
  static String productRatings(int productId) => '/products/$productId/ratings';

  // Query helpers
  static String productsByCategory(int categoryId) =>
      '/products/?category_id=$categoryId';
  static String productsWithFilters({
    String? search,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy, // price_asc, price_desc, name, newest
    int? page,
  }) {
    final params = <String>[];
    if (search != null) params.add('search=$search');
    if (categoryId != null) params.add('category_id=$categoryId');
    if (minPrice != null) params.add('min_price=$minPrice');
    if (maxPrice != null) params.add('max_price=$maxPrice');
    if (sortBy != null) params.add('sort_by=$sortBy');
    if (page != null) params.add('page=$page');
    return '/products/${params.isNotEmpty ? '?${params.join('&')}' : ''}';
  }

  // =========================
  // CART (PROTECTED - BaseApiService)
  // =========================
  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static String removeCartItem(int itemId) => '/cart/item/$itemId';

  // =========================
  // ORDERS (PROTECTED - BaseApiService)
  // =========================
  static const String orders = '/orders';
  static const String createOrder = '/orders/create';
  static String orderDetails(int id) => '/orders/$id';
  static String orderStatus(int id) => '/orders/$id/status';
  static String updateOrderStatus(int id) => '/orders/$id/status';

  // =========================
  // COUPONS (PROTECTED - BaseApiService)
  // =========================
  static const String coupons = '/coupons';
  static String couponDetails(String code) => '/coupons/$code';
  static const String validateCoupon = '/coupons/validate';
  static const String myCouponUsage = '/coupons/my-usage';

  // =========================
  // REVIEWS & RATINGS (PROTECTED - BaseApiService)
  // =========================
  static const String reviews = '/reviews';
  static const String myReviews = '/reviews/my';
  static const String createReview = '/reviews/create';
  static const String markReviewHelpful = '/reviews/helpful';
  static String reviewDetails(int id) => '/reviews/$id';
  static String updateReview(int id) => '/reviews/$id';
  static String deleteReview(int id) => '/reviews/$id';

  // Query helper
  static String reviewsByProduct(int productId, {int? rating, int? page}) {
    final params = <String>['product_id=$productId'];
    if (rating != null) params.add('rating=$rating');
    if (page != null) params.add('page=$page');
    return '/reviews/?${params.join('&')}';
  }

  // =========================
  // ANALYTICS - DASHBOARD (ADMIN ONLY)
  // =========================
  static const String analyticsDashboard = '/analytics/dashboard';
  static const String analyticsRevenueMetrics = '/analytics/revenue/metrics';
  static const String analyticsRevenueDaily = '/analytics/revenue/daily';
  static const String analyticsOrdersStatus = '/analytics/orders/status';
  static const String analyticsProductsPerformance = '/analytics/products/performance';
  static const String analyticsUsersMetrics = '/analytics/users/metrics';
  static const String analyticsReviewsMetrics = '/analytics/reviews/metrics';
  static const String analyticsCouponsPerformance = '/analytics/coupons/performance';

  // =========================
  // AI INSIGHTS (ADMIN ONLY)
  // =========================
  static const String insightsToday = '/analytics/insights/today';
  static const String insightsExplain = '/analytics/insights/explain';
  static const String insightsBusiness = '/analytics/insights/business';

  // =========================
  // PREDICTIONS (ADMIN ONLY)
  // =========================
  static const String predictionsTomorrow = '/analytics/predictions/tomorrow';
  static const String predictionsPromoTimes = '/analytics/predictions/promo-times';
  static const String predictionsInventoryRisks = '/analytics/predictions/inventory-risks';
  static const String predictionsSummary = '/analytics/predictions/summary';

  // =========================
  // ANOMALIES (ADMIN ONLY)
  // =========================
  static const String anomaliesDetect = '/analytics/anomalies/detect';
  static const String anomaliesSummary = '/analytics/anomalies/summary';
  static const String anomaliesDigest = '/analytics/anomalies/digest';
}
