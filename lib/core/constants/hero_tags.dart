/// HeroTags - Centralized hero animation tags
/// Contains all hero tags used across the app for smooth transitions
class HeroTags {
  const HeroTags._();

  // ========= SPLASH & BRANDING =========

  /// App logo/name hero tag used in splash screen
  static const String appLogo = 'BiteGo';

  /// App icon hero tag
  static const String appIcon = 'app_icon';

  /// App brand hero tag
  static const String appBrand = 'app_brand';

  // ========= FOOD & MENU =========

  /// Food item hero tag prefix (append with item ID)
  static const String foodItemPrefix = 'food_item_';

  /// Food image hero tag prefix
  static const String foodImagePrefix = 'food_image_';

  /// Menu item hero tag prefix
  static const String menuItemPrefix = 'menu_item_';

  /// Menu category hero tag prefix
  static const String categoryPrefix = 'category_';

  /// Food price hero tag prefix
  static const String foodPricePrefix = 'food_price_';

  // ========= RESTAURANT =========

  /// Restaurant card hero tag prefix (append with restaurant ID)
  static const String restaurantPrefix = 'restaurant_';

  /// Restaurant logo hero tag prefix
  static const String restaurantLogoPrefix = 'restaurant_logo_';

  /// Restaurant banner hero tag prefix
  static const String restaurantBannerPrefix = 'restaurant_banner_';

  /// Restaurant rating hero tag prefix
  static const String restaurantRatingPrefix = 'restaurant_rating_';

  // ========= USER =========

  /// User profile picture hero tag
  static const String userAvatar = 'user_avatar';

  /// User profile hero tag
  static const String userProfile = 'user_profile';

  /// User name hero tag
  static const String userName = 'user_name';

  /// User badge hero tag
  static const String userBadge = 'user_badge';

  // ========= CART & CHECKOUT =========

  /// Cart icon hero tag
  static const String cartIcon = 'cart_icon';

  /// Cart item hero tag prefix
  static const String cartItemPrefix = 'cart_item_';

  /// Cart badge hero tag
  static const String cartBadge = 'cart_badge';

  /// Checkout button hero tag
  static const String checkoutButton = 'checkout_button';

  // ========= NAVIGATION & UI =========

  /// Bottom navigation bar hero tag
  static const String bottomNavBar = 'bottom_nav_bar';

  /// Search bar hero tag
  static const String searchBar = 'search_bar';

  /// Filter button hero tag
  static const String filterButton = 'filter_button';

  /// Sort button hero tag
  static const String sortButton = 'sort_button';

  // ========= ORDERS =========

  /// Order card hero tag prefix
  static const String orderPrefix = 'order_';

  /// Order status hero tag prefix
  static const String orderStatusPrefix = 'order_status_';

  /// Order tracking hero tag
  static const String orderTracking = 'order_tracking';

  // ========= PROMOTIONS & OFFERS =========

  /// Promo banner hero tag prefix
  static const String promoBannerPrefix = 'promo_banner_';

  /// Offer card hero tag prefix
  static const String offerCardPrefix = 'offer_card_';

  /// Discount badge hero tag prefix
  static const String discountBadgePrefix = 'discount_badge_';

  // ========= HELPER METHODS =========

  /// Generate food item hero tag with ID
  static String foodItem(String id) => '$foodItemPrefix$id';

  /// Generate food image hero tag with ID
  static String foodImage(String id) => '$foodImagePrefix$id';

  /// Generate menu item hero tag with ID
  static String menuItem(String id) => '$menuItemPrefix$id';

  /// Generate category hero tag with ID
  static String category(String id) => '$categoryPrefix$id';

  /// Generate food price hero tag with ID
  static String foodPrice(String id) => '$foodPricePrefix$id';

  /// Generate restaurant hero tag with ID
  static String restaurant(String id) => '$restaurantPrefix$id';

  /// Generate restaurant logo hero tag with ID
  static String restaurantLogo(String id) => '$restaurantLogoPrefix$id';

  /// Generate restaurant banner hero tag with ID
  static String restaurantBanner(String id) => '$restaurantBannerPrefix$id';

  /// Generate restaurant rating hero tag with ID
  static String restaurantRating(String id) => '$restaurantRatingPrefix$id';

  /// Generate cart item hero tag with ID
  static String cartItem(String id) => '$cartItemPrefix$id';

  /// Generate order hero tag with ID
  static String order(String id) => '$orderPrefix$id';

  /// Generate order status hero tag with ID
  static String orderStatus(String id) => '$orderStatusPrefix$id';

  /// Generate promo banner hero tag with ID
  static String promoBanner(String id) => '$promoBannerPrefix$id';

  /// Generate offer card hero tag with ID
  static String offerCard(String id) => '$offerCardPrefix$id';

  /// Generate discount badge hero tag with ID
  static String discountBadge(String id) => '$discountBadgePrefix$id';
}
