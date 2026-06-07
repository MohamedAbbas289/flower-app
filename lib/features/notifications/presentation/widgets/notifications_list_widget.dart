import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/notifications/domain/entities/notifications_entity.dart';
import 'package:flutter/material.dart';
import 'notification_item_widget.dart';

class NotificationsListWidget extends StatelessWidget {
  final NotificationsResponseEntity data;

  const NotificationsListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.notifications.isEmpty) {
      return Center(child: Text(AppStrings.noNotificationsFound));
    }

    return ListView.builder(
      itemCount: data.notifications.length,
      itemBuilder: (context, index) {
        final notification = data.notifications[index];
        return NotificationItemWidget(notification: notification);
      },
    );
  }
}
