import 'package:easy_localization/easy_localization.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/profile/presentation/view_models/notification_toggle_view_model/notification_toggle_state.dart';
import 'package:flower_app/features/profile/presentation/view_models/notification_toggle_view_model/notification_toggle_view_model.dart';
import 'package:flower_app/features/profile/presentation/widgets/row_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationToggle extends StatelessWidget {
  const NotificationToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationToggleViewModel>(),
      child: const _NotificationToggleView(),
    );
  }
}

class _NotificationToggleView extends StatelessWidget {
  const _NotificationToggleView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationToggleViewModel, NotificationToggleState>(
      builder: (context, state) {
        return RowSection.toggle(
          title: AppStrings.notification,
          value: state.enabled,
          onToggle: (value) {
            context.read<NotificationToggleViewModel>().toggle(
              value,
              context.locale.languageCode,
            );
          },
          onTap: () =>
              Navigator.pushNamed(context, AppRoutesName.notifications),
        );
      },
    );
  }
}
