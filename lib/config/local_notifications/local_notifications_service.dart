import 'dart:developer';

import 'package:flower_app/core/values/firebase_constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalNotificationsService {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationsService(this._plugin);

  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        log('Local notification clicked: ${details.payload}');
      },
    );
  }

  Future<AndroidNotificationChannel> createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      FirebaseConstants.highImportanceChannelId,
      FirebaseConstants.highImportanceChannelName,
      description: FirebaseConstants.highImportanceChannelDescription,
      importance: Importance.max,
    );
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(channel);
    return channel;
  }

  void show({
    required int id,
    String? title,
    String? body,
    required NotificationDetails details,
    String? payload,
  }) {
    _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}

@module
abstract class LocalNotificationsModule {
  @lazySingleton
  FlutterLocalNotificationsPlugin get plugin => FlutterLocalNotificationsPlugin();
}
