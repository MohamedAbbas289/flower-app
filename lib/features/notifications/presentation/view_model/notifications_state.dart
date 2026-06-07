import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/notifications/domain/entities/notifications_entity.dart';

class NotificationsState extends Equatable {
  final BaseState<NotificationsResponseEntity> notificationsState;

  const NotificationsState({this.notificationsState = const BaseState()});

  NotificationsState copyWith({
    BaseState<NotificationsResponseEntity>? notificationsState,
  }) {
    return NotificationsState(
      notificationsState: notificationsState ?? this.notificationsState,
    );
  }

  @override
  List<Object> get props => [notificationsState];
}
