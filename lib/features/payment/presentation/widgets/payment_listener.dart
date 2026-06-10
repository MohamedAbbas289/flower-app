import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/payment/presentation/view_model/payment_state.dart';
import 'package:flower_app/features/profile/presentation/widgets/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentListener {
  static void onStateChange(BuildContext context, PaymentState state) {
    // Cash order error
    if (state.cashOrderState.msg != null && state.cashOrderState.data == null) {
      AppSnackBar.showError(
        context,
        state.cashOrderState.msg!,
        icon: SvgPicture.asset(
          Assets.assetsIconsError,
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      );
    }

    // Cash order success
    if (state.cashOrderState.data != null) {
      AppSnackBar.showSuccess(context, AppStrings.cashOrderPlacedSuccessfully);
    }

    // Checkout session error
    if (state.checkoutSessionState.msg != null &&
        state.checkoutSessionState.data == null) {
      AppSnackBar.showError(
        context,
        state.checkoutSessionState.msg!,
        icon: SvgPicture.asset(
          Assets.assetsIconsError,
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      );
    }

    // Checkout session success — open Stripe in WebView
    if (state.checkoutSessionState.data != null) {
      final sessionUrl = state.checkoutSessionState.data!.sessionUrl;

      if (sessionUrl.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                WebViewScreen(url: sessionUrl, title: AppStrings.payment),
          ),
        );
      }
    }
  }
}
