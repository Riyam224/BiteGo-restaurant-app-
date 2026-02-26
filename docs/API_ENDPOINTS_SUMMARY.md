# API Endpoints Quick Reference

**Base URL:** `https://web-production-e1bea.up.railway.app`

---

## 🔐 Authentication (PUBLIC - PublicApiService)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/login` | Login with email/password |
| POST | `/api/v1/auth/register` | Register new user |
| POST | `/api/v1/auth/google` | Google OAuth login |
| POST | `/api/v1/auth/refresh` | Refresh access token |
| POST | `/api/v1/auth/forgot-password` | Send OTP to email |
| POST | `/api/v1/auth/verify-otp` | Verify OTP code |
| POST | `/api/v1/auth/reset-password` | Reset password after OTP |

---

## 👤 Profile (PROTECTED - BaseApiService)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/profile` | Get user profile |

---

## 📍 Addresses (PROTECTED - BaseApiService)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/addresses/` | List user addresses |
| POST | `/api/v1/addresses/` | Create new address |
| GET | `/api/v1/addresses/{id}/` | Get address details |
| PUT | `/api/v1/addresses/{id}/` | Update address (full) |
| PATCH | `/api/v1/addresses/{id}/` | Update address (partial) |
| DELETE | `/api/v1/addresses/{id}/` | Delete address |

---

## 🍽️ Categories & Products (PUBLIC)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/categories/` | List all categories |
| GET | `/api/v1/products/` | List products (search, filter, sort) |
| GET | `/api/v1/products/{id}/` | Get product details |
| GET | `/api/v1/products/{id}/ratings/` | Get product ratings stats |

**Product Query Params:**
- `search` - Search term
- `category_id` - Filter by category
- `min_price`, `max_price` - Price range
- `sort_by` - `price_asc`, `price_desc`, `name`, `newest`
- `page` - Pagination

---

## 🛒 Shopping Cart (PROTECTED - BaseApiService)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/cart/` | Get user's cart |
| POST | `/api/v1/cart/add/` | Add item to cart |
| DELETE | `/api/v1/cart/item/{item_id}/` | Remove cart item |

---

## 📦 Orders (PROTECTED - BaseApiService)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/orders/` | List user orders |
| GET | `/api/v1/orders/{id}/` | Get order details |
| GET | `/api/v1/orders/{id}/status/` | Get order status |
| POST | `/api/v1/orders/create/` | Create order from cart |
| PATCH | `/api/v1/orders/{id}/status/` | Update order status (ADMIN) |

**Order Status Values:**
- `pending`
- `preparing`
- `on_the_way`
- `delivered`
- `cancelled`

---

## 🎟️ Coupons (PROTECTED - BaseApiService)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/coupons/` | List available coupons |
| GET | `/api/v1/coupons/{code}/` | Get coupon details |
| POST | `/api/v1/coupons/validate/` | Validate coupon code |
| GET | `/api/v1/coupons/my-usage/` | List user's coupon usage |

---

## ⭐ Reviews & Ratings (PROTECTED - BaseApiService)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/reviews/` | List product reviews |
| GET | `/api/v1/reviews/my/` | List user's reviews |
| POST | `/api/v1/reviews/create/` | Create review |
| GET | `/api/v1/reviews/{id}/` | Get review details |
| PUT | `/api/v1/reviews/{id}/` | Update review (full) |
| PATCH | `/api/v1/reviews/{id}/` | Update review (partial) |
| DELETE | `/api/v1/reviews/{id}/` | Delete review |
| POST | `/api/v1/reviews/helpful/` | Vote review helpfulness |

**Review Constraints:**
- One review per product per user
- Can edit/delete within 7 days
- Cannot vote on own reviews

---

## 📊 Analytics - Dashboard (ADMIN ONLY)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/analytics/dashboard/` | Dashboard KPIs |
| GET | `/api/v1/analytics/revenue/metrics/` | Revenue summary |
| GET | `/api/v1/analytics/revenue/daily/` | Daily revenue breakdown |
| GET | `/api/v1/analytics/orders/status/` | Order status breakdown |
| GET | `/api/v1/analytics/products/performance/` | Top products |
| GET | `/api/v1/analytics/users/metrics/` | User statistics |
| GET | `/api/v1/analytics/reviews/metrics/` | Review metrics |
| GET | `/api/v1/analytics/coupons/performance/` | Coupon analytics |

---

## 🤖 AI Insights (ADMIN ONLY)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/analytics/insights/today/` | Daily AI summary |
| GET | `/api/v1/analytics/insights/explain/` | Explain metric changes |
| GET | `/api/v1/analytics/insights/business/` | Business insights |

**Query Params:**
- `date` - YYYY-MM-DD format
- `metric` - `revenue`, `orders`, `users`
- `days` - Number of days (default: 30)

---

## 🔮 Predictions (ADMIN ONLY)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/analytics/predictions/tomorrow/` | Tomorrow's forecast |
| GET | `/api/v1/analytics/predictions/promo-times/` | Best promo times |
| GET | `/api/v1/analytics/predictions/inventory-risks/` | Inventory risks |
| GET | `/api/v1/analytics/predictions/summary/` | Prediction summary |

---

## 🚨 Anomaly Detection (ADMIN ONLY)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/analytics/anomalies/detect/` | Detect anomalies |
| GET | `/api/v1/analytics/anomalies/summary/` | Anomaly summary |
| GET | `/api/v1/analytics/anomalies/digest/` | Anomaly digest |

**Query Params:**
- `days` - Number of days (default: 7)
- `use_ai` - Use AI for detection (boolean)

---

## 📋 Common Patterns

### Pagination
Most list endpoints return:
```json
{
  "count": 100,
  "next": "url_to_next_page",
  "previous": "url_to_previous_page",
  "results": [...]
}
```

### Authentication Header
```
Authorization: Bearer <access_token>
```

### Date Format
All dates use ISO 8601: `YYYY-MM-DDTHH:MM:SSZ`

### Response Codes
- `200` - Success
- `201` - Created
- `204` - No Content (delete success)
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500+` - Server Error

---

## 🎯 Feature Implementation Order

### Phase 1: Core Features
1. ✅ Authentication (login, register, Google OAuth)
2. ✅ Profile management
3. ✅ Products browsing
4. 🔄 Cart management
5. 🔄 Orders

### Phase 2: Enhanced Features
6. 📍 Address management
7. 🎟️ Coupons
8. ⭐ Reviews & Ratings

### Phase 3: Admin Features
9. 📊 Analytics dashboard
10. 🤖 AI insights
11. 🔮 Predictions
12. 🚨 Anomaly detection

---

## 🛠️ Service Architecture

```
lib/
├── core/
│   └── networking/
│       ├── dio_client.dart              # Dual-client setup
│       ├── public_api_service.dart      # For PUBLIC endpoints
│       └── base_api_service.dart        # For PROTECTED endpoints
│
└── features/
    ├── auth/
    │   └── data/services/
    │       └── auth_service.dart        # extends PublicApiService
    │
    ├── products/
    │   └── data/services/
    │       └── products_service.dart    # extends PublicApiService (browse)
    │
    ├── cart/
    │   └── data/services/
    │       └── cart_service.dart        # extends BaseApiService
    │
    └── orders/
        └── data/services/
            └── orders_service.dart      # extends BaseApiService
```

---

## 💡 Tips

1. **Always use the correct base service:**
   - Public endpoints (no auth) → `PublicApiService`
   - Protected endpoints (auth required) → `BaseApiService`

2. **Token Management:**
   - Store tokens securely (flutter_secure_storage)
   - Refresh token on 401 errors
   - Clear tokens on logout

3. **Error Handling:**
   - Display user-friendly messages
   - Log errors for debugging
   - Handle network failures gracefully

4. **Pagination:**
   - Implement infinite scroll for lists
   - Cache pages for better UX
   - Show loading indicators

5. **Search & Filters:**
   - Debounce search input (300ms)
   - Clear filters button
   - Show active filter count
