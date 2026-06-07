import 'package:equatable/equatable.dart';

class NotificationsResponseEntity extends Equatable {
  final String message;
  final MetadataEntity metadata;
  final List<NotificationItemEntity> notifications;

  const NotificationsResponseEntity({
    required this.message,
    required this.metadata,
    required this.notifications,
  });

  @override
  List<Object?> get props => [message, metadata, notifications];
}

class MetadataEntity extends Equatable {
  final int currentPage;
  final int totalPages;
  final int limit;
  final int totalItems;
  final int unreadCount;

  const MetadataEntity({
    required this.currentPage,
    required this.totalPages,
    required this.limit,
    required this.totalItems,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    limit,
    totalItems,
    unreadCount,
  ];
}

class NotificationItemEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;

  const NotificationItemEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
  });

  @override
  List<Object?> get props => [id, title, body, receivedAt];
}
