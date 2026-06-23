import 'package:flower_app/core/reusable_widgets/app_dialog.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_models/logout_view_model/logout_events.dart';
import '../view_models/logout_view_model/logout_state.dart';
import '../view_models/logout_view_model/logout_view_model.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onSuccess;
  final void Function(String message) onError;

  const LogoutDialog({
    super.key,
    required this.onSuccess,
    required this.onError,
  });

  static Future<void> show({required BuildContext context}) {
    return AppDialog.show(
      context: context,
      title: AppStrings.logout,
      description: AppStrings.confirmLogout,
      confirmText: AppStrings.logout,
      cancelText: AppStrings.cancel,
      confirmButtonColor: AppColors.red,
      cancelButtonColor: AppColors.pink,
      barrierDismissible: false,
      onConfirm: () =>
          context.read<LogoutViewModel>().doEvent(LogoutRequestEvent()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutViewModel, LogoutState>(
      listenWhen: (previous, current) =>
          previous.logoutState != current.logoutState &&
          !current.logoutState.isLoading,
      listener: (context, state) {
        if (state.logoutState.msg != null) {
          onError(state.logoutState.msg!);
        } else {
          onSuccess();
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
