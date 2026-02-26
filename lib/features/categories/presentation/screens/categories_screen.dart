import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categories = [
      {'name': 'Main Course', 'icon': Icons.restaurant, 'count': 25},
      {'name': 'Italian', 'icon': Icons.local_pizza, 'count': 18},
      {'name': 'Fast Food', 'icon': Icons.fastfood, 'count': 32},
      {'name': 'Salads', 'icon': Icons.eco, 'count': 15},
      {'name': 'Desserts', 'icon': Icons.cake, 'count': 22},
      {'name': 'Beverages', 'icon': Icons.local_cafe, 'count': 28},
      {'name': 'Asian', 'icon': Icons.ramen_dining, 'count': 20},
      {'name': 'Seafood', 'icon': Icons.set_meal, 'count': 12},
      {'name': 'Breakfast', 'icon': Icons.breakfast_dining, 'count': 16},
      {'name': 'Vegan', 'icon': Icons.grass, 'count': 14},
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Categories',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.2,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(
            context,
            name: category['name'] as String,
            icon: category['icon'] as IconData,
            count: category['count'] as int,
            theme: theme,
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String name,
    required IconData icon,
    required int count,
    required ThemeData theme,
  }) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint('Selected category: $name');
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    size: 32.w,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '$count items',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.getTextSecondary(context),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
