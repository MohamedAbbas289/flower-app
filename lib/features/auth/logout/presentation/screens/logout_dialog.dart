import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/logout_events.dart';
import '../view_model/logout_state.dart';
import '../view_model/logout_view_model.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onSuccess;
  final void Function(String message) onError;

  const LogoutDialog({
    super.key,
    required this.onSuccess,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutViewModel, LogoutState>(
      listenWhen: (previous, current) =>
          previous.logoutState != current.logoutState &&
          !current.logoutState.isLoading,
      listener: (context, state) {
        Navigator.of(context, rootNavigator: true).pop();
        if (state.logoutState.msg != null) {
          onError(state.logoutState.msg!);
        } else {
          onSuccess();
        }
      },
      child: AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppStrings.logout.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyles.bodyRegular18.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.logout,
              textAlign: TextAlign.center,
              style: TextStyles.bodyRegular16,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _CancelButton()),
                const SizedBox(width: 12),
                Expanded(child: _LogoutButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 48)),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
      child: Text(AppStrings.cancel),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogoutViewModel, LogoutState>(
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
          onPressed: state.logoutState.isLoading
              ? null
              : () => context.read<LogoutViewModel>().doEvent(
                  LogoutRequestEvent(),
                ),
          child: state.logoutState.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              :  Text(AppStrings.logout),
        );
      },
    );
  }
}
