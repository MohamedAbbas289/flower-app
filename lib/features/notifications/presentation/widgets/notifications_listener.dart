import 'package:flower_app/core/reusable_widgets/app_snack_bar.dart';
import 'package:flower_app/core/values/images_paths.dart';
import 'package:flower_app/features/notifications/presentation/view_model/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationsListener {
  static void onStateChange(BuildContext context, NotificationsState state) {
    if (!state.notificationsState.isLoading &&
        state.notificationsState.msg != null) {
      AppSnackBar.showError(
        context,
        state.notificationsState.msg!,
        icon: SvgPicture.asset(
          Assets.assetsIconsError,
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      );
    }
  }
}
