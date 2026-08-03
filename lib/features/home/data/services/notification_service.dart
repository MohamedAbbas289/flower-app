import 'dart:async';

import 'package:flower_app/features/home/data/models/notification_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationService {
  final List<NotificationModel> _notifications = [];
  final StreamController<int> _unreadCountController =
      StreamController<int>.broadcast();

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Stream<int> get unreadCountStream => _unreadCountController.stream;

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    _unreadCountController.add(unreadCount);
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _unreadCountController.add(0);
  }

  void dispose() {
    _unreadCountController.close();
  }
}
