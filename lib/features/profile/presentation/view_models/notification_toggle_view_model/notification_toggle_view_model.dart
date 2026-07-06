import 'package:flower_app/config/firebase/fcm_service.dart';
import 'package:flower_app/config/secure_storage/secure_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'notification_toggle_state.dart';

@injectable
class NotificationToggleViewModel extends Cubit<NotificationToggleState> {
  final SecureStorageService _storageService;
  final FcmService _fcmService;

  NotificationToggleViewModel(this._storageService, this._fcmService)
      : super(const NotificationToggleState()) {
    _loadState();
  }

  Future<void> _loadState() async {
    final enabled = await _storageService.readNotificationsEnabled();
    emit(state.copyWith(enabled: enabled));
  }

  Future<void> toggle(bool value, String languageCode) async {
    emit(state.copyWith(enabled: value));
    await _storageService.writeNotificationsEnabled(value);
    if (value) {
      final userId = await _storageService.readUserId();
      final token = await _fcmService.getFcmToken();
      if (userId != null &&
          userId.isNotEmpty &&
          token != null &&
          token.isNotEmpty) {
        await _fcmService.saveFcmDataForUser(
          userId: userId,
          fcmToken: token,
          language: languageCode,
        );
      }
    } else {
      await _fcmService.deleteToken();
    }
  }
}
