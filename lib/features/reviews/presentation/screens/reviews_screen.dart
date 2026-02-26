import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final reviews = [
      {
        'id': '1',
        'userName': 'Sarah Johnson',
        'userImage': 'https://i.pravatar.cc/150?img=1',
        'rating': 5.0,
        'date': '2024-02-20',
        'foodItem': 'Chicken Biryani',
        'comment':
            'Absolutely delicious! The flavors were amazing and the portion size was generous. Will definitely order again!',
      },
      {
        'id': '2',
        'userName': 'Mike Chen',
        'userImage': 'https://i.pravatar.cc/150?img=2',
        'rating': 4.0,
        'date': '2024-02-19',
        'foodItem': 'Margherita Pizza',
        'comment':
            'Great pizza with fresh ingredients. The crust was perfect. Delivery was a bit slow but worth the wait.',
      },
      {
        'id': '3',
        'userName': 'Emma Wilson',
        'userImage': 'https://i.pravatar.cc/150?img=3',
        'rating': 5.0,
        'date': '2024-02-18',
        'foodItem': 'Grilled Salmon',
        'comment':
            'Best salmon I\'ve had in a while! Cooked perfectly and the herbs complemented it beautifully.',
      },
      {
        'id': '4',
        'userName': 'David Brown',
        'userImage': 'https://i.pravatar.cc/150?img=4',
        'rating': 3.0,
        'date': '2024-02-17',
        'foodItem': 'Caesar Salad',
        'comment': 'Good salad but a bit expensive for the quantity. Dressing was tasty though.',
      },
      {
        'id': '5',
        'userName': 'Lisa Anderson',
        'userImage': 'https://i.pravatar.cc/150?img=5',
        'rating': 5.0,
        'date': '2024-02-16',
        'foodItem': 'Chocolate Lava Cake',
        'comment': 'Heaven in a dessert! The chocolate was rich and the cake was warm and gooey. Perfect!',
      },
    ];

    final avgRating = reviews.fold<double>(
          0,
          (sum, review) => sum + (review['rating'] as double),
        ) /
        reviews.length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Reviews & Ratings',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          // Overall Rating Summary
          Container(
            padding: EdgeInsets.all(20.w),
            color: AppColors.getCardBackground(context),
            child: Column(
              children: [
                Text(
                  avgRating.toStringAsFixed(1),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 48.sp,
                    color: AppColors.primary,
                  ),
                ),
                _buildStarRating(avgRating, size: 24.w),
                SizedBox(height: 8.h),
                Text(
                  'Based on ${reviews.length} reviews',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),

          // Reviews List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return _buildReviewCard(context, reviews[index], theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    BuildContext context,
    Map<String, dynamic> review,
    ThemeData theme,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.w,
                backgroundImage: NetworkImage(review['userImage'] as String),
                onBackgroundImageError: (_, __) {},
                child: review['userImage'] == null
                    ? Icon(Icons.person, size: 24.w)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      review['date'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.getTextSecondary(context),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.primary,
                      size: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      review['rating'].toString(),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              review['foodItem'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            review['comment'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : index < rating
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }
}
