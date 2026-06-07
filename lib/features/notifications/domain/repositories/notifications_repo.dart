import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/notifications/domain/entities/notifications_entity.dart';

abstract interface class NotificationsRepository {
  Future<BaseResponse<NotificationsResponseEntity>> getUserNotifications({
    int? page,
    int? limit,
  });
}
