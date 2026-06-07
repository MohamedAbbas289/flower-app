import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/notifications/domain/entities/notifications_entity.dart';
import 'package:flower_app/features/notifications/domain/repositories/notifications_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationsUseCase {
  final NotificationsRepository _notificationsRepository;

  GetNotificationsUseCase(this._notificationsRepository);

  Future<BaseResponse<NotificationsResponseEntity>> execute({
    int? page,
    int? limit,
  }) async {
    return await _notificationsRepository.getUserNotifications(
      page: page,
      limit: limit,
    );
  }
}
