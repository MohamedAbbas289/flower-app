import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/notifications/domain/entities/notifications_entity.dart';
import 'package:flower_app/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:flower_app/features/notifications/presentation/view_model/notifications_events.dart';
import 'package:flower_app/features/notifications/presentation/view_model/notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationsViewModel extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;

  NotificationsViewModel(this._getNotificationsUseCase)
    : super(const NotificationsState());

  void doEvent(NotificationsEvent event) {
    switch (event) {
      case GetNotificationsEvent():
        _getNotifications(page: event.page, limit: event.limit);
        break;
    }
  }

  Future<void> _getNotifications({int? page, int? limit}) async {
    emit(state.copyWith(notificationsState: BaseState.loading()));

    final response = await _getNotificationsUseCase.execute(
      page: page,
      limit: limit,
    );

    switch (response) {
      case SuccessBaseResponse<NotificationsResponseEntity>():
        emit(
          state.copyWith(notificationsState: BaseState.success(response.data)),
        );
        break;
      case ErrorBaseResponse<NotificationsResponseEntity>():
        emit(
          state.copyWith(
            notificationsState: BaseState.error(response.errorMessage),
          ),
        );
        break;
    }
  }
}
