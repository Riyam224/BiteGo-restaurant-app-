# Restaurant API Reference

**Base URL:** `https://web-production-e1bea.up.railway.app`

**API Documentation:** https://web-production-e1bea.up.railway.app/api/docs/

---

## Table of Contents

- [Authentication](#authentication)
- [User Profile](#user-profile)
- [Addresses](#addresses)
- [Categories & Products](#categories--products)
- [Shopping Cart](#shopping-cart)
- [Orders](#orders)
- [Coupons](#coupons)
- [Reviews & Ratings](#reviews--ratings)
- [Analytics & Admin](#analytics--admin)
- [AI Insights](#ai-insights)
- [Response Codes](#response-codes)

---

## Authentication

All authentication endpoints are **PUBLIC** (extend `PublicApiService`).

### POST `/api/v1/auth/login`
**Description:** Authenticate user with email/password
**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
**Response:**
```json
{
  "access": "jwt_access_token",
  "refresh": "jwt_refresh_token"
}
```

### POST `/api/v1/auth/register`
**Description:** Create new user account
**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "phone": "+1234567890",  // optional
  "avatar": "url"  // optional
}
```
**Response:** `User` object

### POST `/api/v1/auth/google`
**Description:** Authenticate with Google OAuth
**Request Body:**
```json
{
  "id_token": "google_id_token"
}
```
**Response:** JWT token pair

### POST `/api/v1/auth/refresh`
**Description:** Refresh access token
**Request Body:**
```json
{
  "refresh": "jwt_refresh_token"
}
```
**Response:**
```json
{
  "access": "new_jwt_access_token"
}
```

### POST `/api/v1/auth/forgot-password`
**Description:** Send OTP to email (Step 1)
**Request Body:**
```json
{
  "email": "user@example.com"
}
```
**Response:** OTP confirmation message

### POST `/api/v1/auth/verify-otp`
**Description:** Verify 6-digit OTP (Step 2)
**Request Body:**
```json
{
  "email": "user@example.com",
  "otp": "123456"
}
```
**Response:** Verification confirmation

### POST `/api/v1/auth/reset-password`
**Description:** Reset password after OTP verification (Step 3)
**Request Body:**
```json
{
  "email": "user@example.com",
  "otp": "123456",
  "new_password": "newpassword123",
  "confirm_password": "newpassword123"
}
```
**Response:** Success message

---

## User Profile

**Authentication Required** (extend `BaseApiService`)

### GET `/api/v1/profile`
**Description:** Get authenticated user profile
**Response:**
```json
{
  "id": 1,
  "email": "user@example.com",
  "username": "username",
  "phone": "+1234567890",
  "avatar": "url",
  "created_at": "2024-01-01T00:00:00Z"
}
```

---

## Addresses

**Authentication Required** (extend `BaseApiService`)

### GET `/api/v1/addresses/`
**Description:** List user's addresses (paginated)
**Query Params:** `page` (optional)
**Response:**
```json
{
  "count": 10,
  "next": "url",
  "previous": null,
  "results": [
    {
      "id": 1,
      "label": "Home",
      "city": "New York",
      "street": "5th Avenue",
      "building": "Building 10",
      "lat": 40.7580,
      "lng": -73.9855
    }
  ]
}
```

### POST `/api/v1/addresses/`
**Description:** Create new address
**Request Body:**
```json
{
  "label": "Home",
  "city": "New York",
  "street": "5th Avenue",
  "building": "Building 10",
  "lat": 40.7580,
  "lng": -73.9855
}
```
**Response:** Created `Address` object

### GET `/api/v1/addresses/{id}/`
**Description:** Get single address details

### PUT `/api/v1/addresses/{id}/`
**Description:** Update entire address

### PATCH `/api/v1/addresses/{id}/`
**Description:** Partially update address

### DELETE `/api/v1/addresses/{id}/`
**Description:** Delete address
**Response:** 204 No Content

---

## Categories & Products

### GET `/api/v1/categories/`
**Description:** List all active categories (PUBLIC)
**Query Params:** `page` (optional)
**Response:**
```json
{
  "count": 5,
  "results": [
    {
      "id": 1,
      "name": "Main Course",
      "description": "Delicious main dishes",
      "image_url": "url",
      "is_active": true
    }
  ]
}
```

### GET `/api/v1/products/`
**Description:** List products with search & filtering (PUBLIC)
**Query Params:**
- `search` - Search by name/description
- `category_id` - Filter by category
- `min_price` - Minimum price
- `max_price` - Maximum price
- `sort_by` - Sort: `price_asc`, `price_desc`, `name`, `newest`
- `page` - Page number

**Response:**
```json
{
  "count": 50,
  "results": [
    {
      "id": 1,
      "name": "Chicken Biryani",
      "description": "Aromatic rice dish",
      "price": 15.99,
      "imageUrl": "url",
      "image_url": "url",
      "category": "Main Course",
      "category_id": 1,
      "category_name": "Main Course",
      "rating": 4.5,
      "reviewCount": 62,
      "review_count": 62,
      "isAvailable": true,
      "is_available": true,
      "tags": ["Popular", "Spicy"],
      "nutritionInfo": {},
      "nutrition_info": {},
      "created_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### GET `/api/v1/products/{id}/`
**Description:** Get single product details (PUBLIC)

### GET `/api/v1/products/{product_id}/ratings/`
**Description:** Get product rating statistics (PUBLIC)
**Response:**
```json
{
  "average_rating": 4.5,
  "total_reviews": 62,
  "rating_distribution": {
    "5": 30,
    "4": 20,
    "3": 8,
    "2": 3,
    "1": 1
  }
}
```

---

## Shopping Cart

**Authentication Required** (extend `BaseApiService`)

### GET `/api/v1/cart/`
**Description:** Get user's current cart
**Response:**
```json
{
  "id": 1,
  "items": [
    {
      "id": 1,
      "product": {
        "id": 1,
        "name": "Chicken Biryani",
        "price": 15.99,
        "imageUrl": "url"
      },
      "quantity": 2,
      "subtotal": 31.98
    }
  ],
  "total_items": 2,
  "total_price": 31.98
}
```

### POST `/api/v1/cart/add/`
**Description:** Add product to cart
**Request Body:**
```json
{
  "product_id": 1,
  "quantity": 2
}
```
**Response:** Updated cart object

### DELETE `/api/v1/cart/item/{item_id}/`
**Description:** Remove item from cart
**Response:** Updated cart object

---

## Orders

**Authentication Required** (extend `BaseApiService`)

### GET `/api/v1/orders/`
**Description:** List user's orders (paginated)
**Query Params:** `page` (optional)
**Response:**
```json
{
  "count": 10,
  "results": [
    {
      "id": 1,
      "order_number": "ORD-2024-001",
      "status": "delivered",
      "items": [...],
      "address": {...},
      "total_price": 45.99,
      "discount_amount": 5.00,
      "final_price": 40.99,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T12:00:00Z"
    }
  ]
}
```

### GET `/api/v1/orders/{id}/`
**Description:** Get single order details

### GET `/api/v1/orders/{id}/status/`
**Description:** Get order status
**Response:**
```json
{
  "order_id": 1,
  "status": "on_the_way",
  "updated_at": "2024-01-01T12:00:00Z"
}
```

### PATCH `/api/v1/orders/{id}/status/`
**Description:** Update order status (ADMIN ONLY)
**Request Body:**
```json
{
  "status": "preparing"
}
```
**Valid Status Values:**
- `pending`
- `preparing`
- `on_the_way`
- `delivered`
- `cancelled`

### POST `/api/v1/orders/create/`
**Description:** Create order from cart
**Request Body:**
```json
{
  "address_id": 1,
  "coupon_code": "WELCOME10"  // optional
}
```
**Response:** Order confirmation (201 Created)

---

## Coupons

**Authentication Required** (extend `BaseApiService`)

### GET `/api/v1/coupons/`
**Description:** List available coupons
**Query Params:** `page` (optional)
**Response:**
```json
{
  "count": 5,
  "results": [
    {
      "code": "WELCOME10",
      "description": "10% off first order",
      "discount_type": "percentage",
      "discount_value": 10.0,
      "min_order_amount": 20.0,
      "max_discount": 50.0,
      "valid_from": "2024-01-01T00:00:00Z",
      "valid_until": "2024-12-31T23:59:59Z",
      "usage_limit": 100,
      "usage_count": 45,
      "is_active": true
    }
  ]
}
```

### GET `/api/v1/coupons/{code}/`
**Description:** Get specific coupon details

### POST `/api/v1/coupons/validate/`
**Description:** Validate coupon and calculate discount
**Request Body:**
```json
{
  "code": "WELCOME10",
  "order_amount": 50.00
}
```
**Response:**
```json
{
  "valid": true,
  "discount_amount": 5.00,
  "final_amount": 45.00,
  "message": "Coupon applied successfully"
}
```

### GET `/api/v1/coupons/my-usage/`
**Description:** List user's coupon usage history
**Query Params:** `page` (optional)

---

## Reviews & Ratings

**Authentication Required** (extend `BaseApiService`)

### GET `/api/v1/reviews/`
**Description:** List product reviews (PUBLIC for approved reviews)
**Query Params:**
- `product_id` (required)
- `rating` (optional, 1-5)
- `page` (optional)

**Response:**
```json
{
  "count": 20,
  "results": [
    {
      "id": 1,
      "user": {
        "id": 1,
        "username": "johndoe",
        "avatar": "url"
      },
      "product_id": 1,
      "rating": 5,
      "comment": "Absolutely delicious!",
      "order_id": 10,
      "is_verified_purchase": true,
      "helpful_count": 15,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

### GET `/api/v1/reviews/my/`
**Description:** List user's own reviews
**Query Params:** `page` (optional)

### POST `/api/v1/reviews/create/`
**Description:** Create product review (one per product per user)
**Request Body:**
```json
{
  "product_id": 1,
  "rating": 5,
  "comment": "Absolutely delicious!",  // optional
  "order_id": 10  // optional
}
```
**Response:** Created review (201 Created)

### GET `/api/v1/reviews/{id}/`
**Description:** Get single review details

### PUT `/api/v1/reviews/{id}/`
**Description:** Full update review (owner only, within 7 days)

### PATCH `/api/v1/reviews/{id}/`
**Description:** Partial update review (owner only, within 7 days)
**Request Body:**
```json
{
  "rating": 4,
  "comment": "Updated review text"
}
```

### DELETE `/api/v1/reviews/{id}/`
**Description:** Delete review (owner only, within 7 days)
**Response:** 204 No Content

### POST `/api/v1/reviews/helpful/`
**Description:** Vote on review helpfulness
**Request Body:**
```json
{
  "review_id": 1,
  "is_helpful": true
}
```
**Response:** Vote recorded (201 Created)

---

## Analytics & Admin

**Authentication Required - ADMIN ONLY** (extend `BaseApiService`)

### GET `/api/v1/analytics/dashboard/`
**Description:** Get dashboard KPIs
**Query Params:** `days` (default: 30)
**Response:**
```json
{
  "total_revenue": 15000.00,
  "total_orders": 250,
  "average_order_value": 60.00,
  "total_users": 500,
  "active_users_30d": 150,
  "order_status_breakdown": {
    "pending": 10,
    "preparing": 5,
    "on_the_way": 3,
    "delivered": 200,
    "cancelled": 32
  },
  "revenue_change_percent": 15.5,
  "orders_change_percent": 12.3
}
```

### GET `/api/v1/analytics/revenue/metrics/`
**Description:** Revenue summary
**Query Params:** `start_date`, `end_date` (YYYY-MM-DD)

### GET `/api/v1/analytics/revenue/daily/`
**Description:** Daily revenue breakdown for charts
**Query Params:** `start_date`, `end_date`
**Response:**
```json
[
  {
    "date": "2024-01-01",
    "revenue": 1500.00,
    "order_count": 25
  }
]
```

### GET `/api/v1/analytics/orders/status/`
**Description:** Order status breakdown

### GET `/api/v1/analytics/products/performance/`
**Description:** Top-selling products
**Response:**
```json
[
  {
    "product_id": 1,
    "product_name": "Chicken Biryani",
    "quantity_sold": 150,
    "total_revenue": 2398.50,
    "order_count": 75
  }
]
```

### GET `/api/v1/analytics/users/metrics/`
**Description:** User statistics and top customers

### GET `/api/v1/analytics/reviews/metrics/`
**Description:** Review statistics and rating distribution

### GET `/api/v1/analytics/coupons/performance/`
**Description:** Coupon usage and discount analytics

---

## AI Insights

**Authentication Required - ADMIN ONLY** (extend `BaseApiService`)

### GET `/api/v1/analytics/insights/today/`
**Description:** AI-generated daily summary
**Query Params:** `date` (optional, YYYY-MM-DD)
**Response:**
```json
{
  "headline": "Strong Performance Today",
  "summary": "Orders up 15%, revenue trending positive...",
  "metrics": {
    "revenue": 2500.00,
    "orders": 45
  },
  "changes": {
    "revenue": "+15%",
    "orders": "+12%"
  },
  "insights": [
    "Peak ordering time: 7-9 PM",
    "Most popular: Chicken Biryani"
  ]
}
```

### GET `/api/v1/analytics/insights/explain/`
**Description:** AI explanation for metric changes
**Query Params:**
- `metric` (required: `revenue`, `orders`, `users`)
- `days` (default: 30)

**Response:**
```json
{
  "metric": "revenue",
  "trend": "increasing",
  "change_percent": 15.5,
  "explanation": "Revenue increased due to successful promotion...",
  "contributing_factors": [
    "New customer acquisition up 20%",
    "Average order value increased"
  ]
}
```

### GET `/api/v1/analytics/insights/business/`
**Description:** Comprehensive business analysis
**Query Params:** `days` (default: 30)
**Response:**
```json
{
  "overview": "Business is performing well...",
  "opportunities": [
    "Expand lunch menu options",
    "Target weekend promotions"
  ],
  "warnings": [
    "Low stock on popular items"
  ],
  "recommendations": [
    "Increase inventory for Biryani",
    "Launch weekend special offers"
  ],
  "key_metrics": {...}
}
```

### GET `/api/v1/analytics/predictions/tomorrow/`
**Description:** Forecast tomorrow's orders and revenue
**Response:**
```json
{
  "predicted_orders": 55,
  "predicted_revenue": 3300.00,
  "confidence": 0.85
}
```

### GET `/api/v1/analytics/predictions/promo-times/`
**Description:** Optimal promotion timing
**Query Params:** `days_ahead` (default: 7)

### GET `/api/v1/analytics/predictions/inventory-risks/`
**Description:** Stock-out risk predictions
**Query Params:** `days_ahead` (default: 7)

### GET `/api/v1/analytics/predictions/summary/`
**Description:** Consolidated predictions overview

### GET `/api/v1/analytics/anomalies/detect/`
**Description:** Detect unusual patterns
**Query Params:**
- `days` (default: 7)
- `use_ai` (boolean)

**Response:**
```json
{
  "anomalies": [
    {
      "type": "revenue_spike",
      "severity": "warning",
      "date": "2024-01-15",
      "description": "Revenue 45% above average",
      "explanation": "Likely due to weekend rush"
    }
  ],
  "total_count": 3,
  "by_severity": {
    "critical": 0,
    "warning": 2,
    "info": 1
  }
}
```

### GET `/api/v1/analytics/anomalies/summary/`
**Description:** Anomaly overview by severity
**Query Params:** `days` (default: 7)

### GET `/api/v1/analytics/anomalies/digest/`
**Description:** Formatted anomaly digest for notifications

---

## Response Codes

| Code | Description |
|------|-------------|
| 200  | OK - Successful GET/POST/PATCH |
| 201  | Created - Successful resource creation |
| 204  | No Content - Successful deletion |
| 400  | Bad Request - Validation errors |
| 401  | Unauthorized - Missing/invalid auth |
| 403  | Forbidden - Permission denied |
| 404  | Not Found - Resource not found |
| 500+ | Server Error - Backend failure |

---

## Authentication Methods

### JWT (Bearer Token)
```
Authorization: Bearer <access_token>
```
Used for all authenticated endpoints.

### API Key (Optional)
```
X-API-Key: <api_key>
```
Alternative authentication method.

---

## Best Practices

1. **Use Correct Base Service:**
   - Public endpoints (auth, register, products) → extend `PublicApiService`
   - Protected endpoints (profile, cart, orders) → extend `BaseApiService`

2. **Error Handling:**
   - Always handle 401 (token expired) → refresh token
   - Handle 400 (validation errors) → show user feedback
   - Handle 404 (not found) → navigate to error page

3. **Pagination:**
   - Most list endpoints support `page` query parameter
   - Response includes `count`, `next`, `previous` fields

4. **Search & Filtering:**
   - Products endpoint supports comprehensive filtering
   - Use query parameters for search and filters

5. **Review System:**
   - One review per product per user
   - Can edit/delete within 7 days
   - Cannot vote on own reviews

6. **Order Flow:**
   1. Add items to cart (`POST /api/v1/cart/add/`)
   2. Create order (`POST /api/v1/orders/create/`)
   3. Track status (`GET /api/v1/orders/{id}/status/`)

7. **Coupon Validation:**
   - Always validate before applying to order
   - Check usage limits and expiry dates
