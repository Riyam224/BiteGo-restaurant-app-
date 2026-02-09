import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_app/core/constants/app_spacing.dart';
import 'package:restaurant_app/core/config/app_text_styles.dart';
import 'package:restaurant_app/core/utils/app_colors.dart';

/// Success Dialog Widget
///
/// Displays an animated success dialog with a checkmark animation
/// Used for confirming successful operations like login, registration, etc.
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onComplete;
  final Duration autoCloseDuration;

  const SuccessDialog({
    super.key,
    required this.title,
    required this.message,
    this.onComplete,
    this.autoCloseDuration = const Duration(seconds: 2),
  });

  /// Show success dialog
  ///
  /// Automatically closes after [autoCloseDuration] and calls [onComplete]
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onComplete,
    Duration autoCloseDuration = const Duration(seconds: 2),
  }) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => SuccessDialog(
        title: title,
        message: message,
        onComplete: onComplete,
        autoCloseDuration: autoCloseDuration,
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Auto-close the dialog after the specified duration
    Future.delayed(autoCloseDuration, () async {
      if (context.mounted) {
        Navigator.of(context).pop();
        // Add a small delay before navigating for smoother transition
        await Future.delayed(const Duration(milliseconds: 300));
        // Call onComplete without context dependency
        onComplete?.call();
      }
    });

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
          vertical: 32.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie Animation
            SizedBox(
              width: 120.w,
              height: 120.h,
              child: Lottie.asset(
                'assets/lottie/Check Mark.json',
                repeat: false,
              ),
            ),
            AppSpacing.gapH16,

            // Title
            Text(
              title,
              style: AppTextStyles.welcomeTitle.copyWith(
                fontSize: 24.sp,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapH12,

            // Message
            Text(
              message,
              style: AppTextStyles.welcomeDescription.copyWith(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
