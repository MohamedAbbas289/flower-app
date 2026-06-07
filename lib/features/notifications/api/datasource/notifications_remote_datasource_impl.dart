import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/notifications/data/datasource/notifications_remote_datasource.dart';
import 'package:flower_app/features/notifications/data/models/notifications_response.dart';
import 'package:injectable/injectable.dart';

import '../api_client/notifications_api_client.dart';

@Injectable(as: NotificationsRemoteDatasource)
class NotificationsRemoteDatasourceImpl
    implements NotificationsRemoteDatasource {
  final NotificationsApiClient _notificationsApiClient;

  NotificationsRemoteDatasourceImpl(this._notificationsApiClient);

  @override
  Future<BaseResponse<NotificationsResponse>> getUserNotifications({
    int? page,
    int? limit,
  }) async {
    try {
      final response = await _notificationsApiClient.getUserNotifications(
        page: page,
        limit: limit,
      );
      return SuccessBaseResponse<NotificationsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<NotificationsResponse>(exception: e);
    }
  }
}
