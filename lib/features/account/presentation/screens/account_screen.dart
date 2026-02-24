import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/constants/app_assets.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                // Header
                Text(
                  'Account',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                SizedBox(height: 24.h),

                // Profile Card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.getCardBackground(context),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.getCardBorder(context),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Profile Picture
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage(AppAssets.profileGirl),
                            fit: BoxFit.cover,
                          ),
                          shape: const OvalBorder(),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sakib Hossen',
                              style: AppTextStyles.restaurantTitle.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.getTextPrimary(context),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'sakib@example.com',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.getTextSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.getTextSecondary(context),
                        size: 24.sp,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Account Settings Section
                Text(
                  'Account Settings',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                SizedBox(height: 12.h),

                _SettingItem(
                  icon: Icons.settings_outlined,
                  title: 'Account setting',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.language,
                  title: 'Language',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.feedback_outlined,
                  title: 'Feedback',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.star_outline,
                  title: 'Rate us',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.info_outline,
                  title: 'New Version',
                  onTap: () {},
                ),

                SizedBox(height: 24.h),

                // Logout Button
                GestureDetector(
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        'Logout',
                        style: AppTextStyles.buttonPrimary.copyWith(
                          color: AppColors.error,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getCardBackground(context),
        title: Text(
          'Logout',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.getTextPrimary(context),
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.getTextSecondary(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonSecondary.copyWith(
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
              debugPrint('Logout confirmed');
            },
            child: Text(
              'Logout',
              style: AppTextStyles.buttonSecondary.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.getCardBorder(context),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: AppColors.getTextSecondary(context),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.getTextPrimary(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: AppColors.getTextSecondary(context),
            ),
          ],
        ),
      ),
    );
  }
}
