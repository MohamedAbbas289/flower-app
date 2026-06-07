import 'package:flower_app/features/notifications/data/models/notifications_response.dart';
import 'package:flower_app/features/notifications/domain/entities/notifications_entity.dart';

extension NotificationsResponseMapper on NotificationsResponse {
  NotificationsResponseEntity toEntity() {
    return NotificationsResponseEntity(
      message: message ?? '',
      metadata:
          metadata?.toEntity() ??
          const MetadataEntity(
            currentPage: 1,
            totalPages: 0,
            limit: 40,
            totalItems: 0,
            unreadCount: 0,
          ),
      notifications:
          notifications?.map((item) => item.toEntity()).toList() ?? [],
    );
  }
}

extension MetadataMapper on MetadataModel {
  MetadataEntity toEntity() {
    return MetadataEntity(
      currentPage: currentPage ?? 1,
      totalPages: totalPages ?? 0,
      limit: limit ?? 40,
      totalItems: totalItems ?? 0,
      unreadCount: unreadCount ?? 0,
    );
  }
}

extension NotificationItemMapper on NotificationItemModel {
  NotificationItemEntity toEntity() {
    return NotificationItemEntity(
      id: id ?? '',
      title: title ?? '',
      body: body ?? '',
      receivedAt: createdAt != null
          ? DateTime.parse(createdAt!)
          : DateTime.now(),
    );
  }
}
