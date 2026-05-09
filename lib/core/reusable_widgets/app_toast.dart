import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  AppToast._();

  static final FToast _fToast = FToast();

  static void init(BuildContext context) {
    _fToast.init(context);
  }

  static void showSuccess({required String message, Widget? icon}) {
    _show(message: message, backgroundColor: AppColors.green, icon: icon);
  }

  static void showError({required String message, Widget? icon}) {
    _show(message: message, backgroundColor: AppColors.red, icon: icon);
  }

  static void _show({
    required String message,
    required Color backgroundColor,
    Widget? icon,
  }) {
    _fToast.showToast(
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),

      child: _ToastBody(
        message: message,
        backgroundColor: backgroundColor,
        icon: icon,
      ),
    );
  }
}

class _ToastBody extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Widget? icon;

  const _ToastBody({
    required this.message,
    required this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 12)],

          Flexible(
            child: Text(
              message,
              style: TextStyles.bodyRegular14.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
