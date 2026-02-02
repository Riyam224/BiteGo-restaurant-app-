import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/auth_tabs.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/login_form.dart';
import 'package:restaurant_app/features/auth/presentation/widgets/register_form.dart';

class AuthBottomSheet extends StatefulWidget {
  final AuthType authType;

  const AuthBottomSheet({super.key, required this.authType});

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet> {
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.authType == AuthType.login;
  }

  void _switchToLogin() {
    setState(() => _isLogin = true);
  }

  void _switchToRegister() {
    setState(() => _isLogin = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.r),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              _buildDragHandle(theme),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: AuthTabs(
                  isLogin: _isLogin,
                  onLoginTap: _switchToLogin,
                  onRegisterTap: _switchToRegister,
                ),
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: _isLogin
                      ? const LoginForm()
                      : const RegisterForm(),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(ThemeData theme) {
    return Container(
      width: 48.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey.shade700
            : const Color(0xFFD2D4D8),
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}
