import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/notifications/data/datasource/notifications_remote_datasource.dart';
import 'package:flower_app/features/notifications/data/models/notifications_mapper.dart';
import 'package:flower_app/features/notifications/data/models/notifications_response.dart'; // import للموديل والمابر
import 'package:flower_app/features/notifications/domain/entities/notifications_entity.dart';
import 'package:flower_app/features/notifications/domain/repositories/notifications_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDatasource _remoteDataSource;

  NotificationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<NotificationsResponseEntity>> getUserNotifications({
    int? page,
    int? limit,
  }) async {
    final response = await _remoteDataSource.getUserNotifications(
      page: page,
      limit: limit,
    );

    switch (response) {
      case SuccessBaseResponse<NotificationsResponse>():
        final entity = response.data.toEntity();
        return SuccessBaseResponse<NotificationsResponseEntity>(data: entity);

      case ErrorBaseResponse<NotificationsResponse>():
        return ErrorBaseResponse<NotificationsResponseEntity>(
          exception: response.exception,
        );
    }
  }
}
