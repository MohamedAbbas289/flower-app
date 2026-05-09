import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSnackBar {
  AppSnackBar._();

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _show({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    SvgPicture? icon,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    return messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 2),

        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),

          child: Row(
            children: [
              if (icon != null) ...[icon, const SizedBox(width: 12)],

              Expanded(
                child: Text(
                  message,
                  style: TextStyles.bodyRegular14.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccess(
    BuildContext context,
    String message, {
    SvgPicture? icon,
  }) {
    return _show(
      context: context,
      message: message,
      backgroundColor: AppColors.green,
      icon: icon,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
    BuildContext context,
    String message, {
    SvgPicture? icon,
  }) {
    return _show(
      context: context,
      message: message,
      backgroundColor: AppColors.red,
      icon: icon,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showWarning(
    BuildContext context,
    String message, {
    SvgPicture? icon,
  }) {
    return _show(
      context: context,
      message: message,
      backgroundColor: Colors.orange,
      icon: icon,
    );
  }
}
