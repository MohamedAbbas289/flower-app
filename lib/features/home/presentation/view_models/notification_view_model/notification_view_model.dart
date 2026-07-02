import 'package:flower_app/features/home/data/services/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'notification_event.dart';
import 'notification_state.dart';

@injectable
class NotificationViewModel extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;

  NotificationViewModel(this._notificationService)
      : super(const NotificationState()) {
    on<LoadNotificationsEvent>(_onLoad);
  }

  void _onLoad(LoadNotificationsEvent event, Emitter<NotificationState> emit) {
    _notificationService.markAllAsRead();
    emit(NotificationState(notifications: _notificationService.notifications));
  }
}
