import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTabs extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterTap;

  const AuthTabs({
    super.key,
    required this.isLogin,
    required this.onLoginTap,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AuthTabItem(
            text: 'Create Account',
            isActive: !isLogin,
            onTap: onRegisterTap,
          ),
        ),
        Expanded(
          child: _AuthTabItem(
            text: 'Login',
            isActive: isLogin,
            onTap: onLoginTap,
          ),
        ),
      ],
    );
  }
}

class _AuthTabItem extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const _AuthTabItem({
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? const Color(0xFF4CAF50)
                  : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5) ??
                      Colors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 3.h,
            width: isActive ? 40.w : 0,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }
}
