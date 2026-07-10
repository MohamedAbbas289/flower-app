import 'package:flower_app/features/profile/domain/use_cases/get_notifications_enabled_use_case.dart';
import 'package:flower_app/features/profile/domain/use_cases/toggle_notifications_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'notification_toggle_state.dart';

@injectable
class NotificationToggleViewModel extends Cubit<NotificationToggleState> {
  final GetNotificationsEnabledUseCase _getNotificationsEnabledUseCase;
  final ToggleNotificationsUseCase _toggleNotificationsUseCase;

  NotificationToggleViewModel(
    this._getNotificationsEnabledUseCase,
    this._toggleNotificationsUseCase,
  ) : super(const NotificationToggleState()) {
    _loadState();
  }

  Future<void> _loadState() async {
    final enabled = await _getNotificationsEnabledUseCase.execute();
    emit(state.copyWith(enabled: enabled));
  }

  Future<void> toggle(bool value, String languageCode) async {
    emit(state.copyWith(enabled: value));
    await _toggleNotificationsUseCase.execute(value, languageCode);
  }
}
