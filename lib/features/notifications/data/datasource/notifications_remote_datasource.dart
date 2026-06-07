import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/notifications/data/models/notifications_response.dart';

abstract interface class NotificationsRemoteDatasource {
  Future<BaseResponse<NotificationsResponse>> getUserNotifications({
    int? page,
    int? limit,
  });
}
