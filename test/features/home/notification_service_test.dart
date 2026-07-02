import 'dart:async';

import 'package:flower_app/features/home/data/models/notification_model.dart';
import 'package:flower_app/features/home/data/services/notification_service.dart';
import 'package:test/test.dart';

NotificationModel _makeNotification(String id) => NotificationModel(
      id: id,
      title: 'Title $id',
      body: 'Body $id',
      receivedAt: DateTime.now(),
      isRead: false,
    );

void main() {
  late NotificationService service;

  setUp(() {
    service = NotificationService();
  });

  tearDown(() {
    service.dispose();
  });

  group('NotificationService', () {
    test('initial unreadCount is 0', () {
      expect(service.unreadCount, 0);
    });

    test('initial notifications list is empty', () {
      expect(service.notifications, isEmpty);
    });

    test('addNotification increases unreadCount to 1', () {
      service.addNotification(_makeNotification('1'));
      expect(service.unreadCount, 1);
    });

    test('addNotification x3 results in unreadCount = 3', () {
      service.addNotification(_makeNotification('1'));
      service.addNotification(_makeNotification('2'));
      service.addNotification(_makeNotification('3'));
      expect(service.unreadCount, 3);
    });

    test('markAllAsRead sets unreadCount to 0', () {
      service.addNotification(_makeNotification('1'));
      service.addNotification(_makeNotification('2'));
      service.markAllAsRead();
      expect(service.unreadCount, 0);
    });

    test('markAllAsRead marks all notifications as read', () {
      service.addNotification(_makeNotification('1'));
      service.addNotification(_makeNotification('2'));
      service.markAllAsRead();
      expect(service.notifications.every((n) => n.isRead), isTrue);
    });

    test('notifications are prepended (newest first)', () {
      service.addNotification(_makeNotification('first'));
      service.addNotification(_makeNotification('second'));
      expect(service.notifications.first.id, 'second');
    });

    test('unreadCountStream emits new count on addNotification', () async {
      final counts = <int>[];
      final sub = service.unreadCountStream.listen(counts.add);
      service.addNotification(_makeNotification('1'));
      service.addNotification(_makeNotification('2'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await sub.cancel();
      expect(counts, [1, 2]);
    });

    test('unreadCountStream emits 0 after markAllAsRead', () async {
      final counts = <int>[];
      service.addNotification(_makeNotification('1'));
      final sub = service.unreadCountStream.listen(counts.add);
      service.markAllAsRead();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await sub.cancel();
      expect(counts.last, 0);
    });
  });
}
