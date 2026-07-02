import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/theme/app_colors.dart';
import 'package:flower_app/core/theme/text_styles.dart';
import 'package:flower_app/features/home/data/models/notification_model.dart';
import 'package:flower_app/features/home/presentation/view_models/notification_view_model/notification_event.dart';
import 'package:flower_app/features/home/presentation/view_models/notification_view_model/notification_state.dart';
import 'package:flower_app/features/home/presentation/view_models/notification_view_model/notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<NotificationViewModel>()..add(LoadNotificationsEvent()),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('Notification'),
      ),
      body: BlocBuilder<NotificationViewModel, NotificationState>(
        builder: (context, state) {
          if (state.notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet',
                style: TextStyles.bodyRegular16.copyWith(color: AppColors.gray),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.notifications.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _NotificationItem(
                notification: state.notifications[index],
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.notifications_outlined,
            color: AppColors.pink,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyles.bodyRegular14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.body,
                  style: TextStyles.bodyRegular12.copyWith(
                    color: AppColors.gray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
