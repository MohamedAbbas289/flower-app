import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/config/secure_storage/secure_storage_service.dart';
import 'package:flower_app/core/values/firebase_constants.dart';
import 'package:flower_app/features/home/data/models/notification_model.dart';
import 'package:flower_app/features/home/data/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('--- Background Message Received ---');
  log('Message ID: ${message.messageId}');
  if (message.notification != null) {
    log('Title: ${message.notification?.title}');
    log('Body: ${message.notification?.body}');
  }
  if (message.data.isNotEmpty) {
    log('Data Payload: ${message.data}');
  }
  log('------------------------------------');
}

final FlutterLocalNotificationsPlugin localNotifs =
    FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iOSInit = DarwinInitializationSettings();

  const initSettings = InitializationSettings(
    android: androidInit,
    iOS: iOSInit,
  );

  await localNotifs.initialize(
    settings: initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse details) {
      log('Local notification clicked: ${details.payload}');
    },
  );
}

@lazySingleton
class FcmService {
  final FirebaseMessaging _messaging;
  final FirestoreService _firestoreService;
  final AuthManager _authManager;
  final SecureStorageService _storageService;

  FcmService(
    this._messaging,
    this._firestoreService,
    this._authManager,
    this._storageService,
  );

  Future<String?> getFcmToken() => _messaging.getToken();

  Future<void> deleteToken() => _messaging.deleteToken();

  Future<void> saveFcmDataForUser({
    required String userId,
    required String fcmToken,
    required String language,
  }) => _firestoreService.saveUserFcmData(
        userId: userId,
        fcmToken: fcmToken,
        language: language,
      );

  Future<void> initNotification() async {
    try {
      await _requestPermission();

      if (Platform.isIOS) {
        final available = await _validateApnsToken();
        if (!available) return;
      }

      await _saveFcmTokenForCurrentUser();
      _listenToTokenRefresh();
      await initLocalNotifications();
      await _configureIosPresentationOptions();
      final channel = await _createAndroidChannel();
      _listenToForegroundMessages(channel);
      _registerBackgroundHandler();
      _handleNotificationTap();
      await _handleLaunchFromNotification();
    } catch (e, stack) {
      log('FCM init failed: $e', stackTrace: stack);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    log('Notification permission: ${settings.authorizationStatus}');
  }

  Future<bool> _validateApnsToken() async {
    try {
      final apnsToken = await _messaging
          .getAPNSToken()
          .timeout(const Duration(seconds: 5));
      if (apnsToken == null) {
        log('iOS Push Notifications: Not available (APNs not configured)');
        return false;
      }
      log('APNs token ready: $apnsToken');
      return true;
    } catch (_) {
      log('iOS Push Notifications: Not available');
      return false;
    }
  }

  Future<void> _saveFcmTokenForCurrentUser() async {
    final fcmToken = await _messaging.getToken();
    if (fcmToken == null) return;
    final userId = _authManager.userId;
    if (userId == null || userId.isEmpty) return;
    final language = await _storageService.readLanguage();
    await _firestoreService.saveUserFcmData(
      userId: userId,
      fcmToken: fcmToken,
      language: language,
    );
  }

  void _listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      final userId = _authManager.userId;
      if (userId == null || userId.isEmpty) return;
      final language = await _storageService.readLanguage();
      await _firestoreService.saveUserFcmData(
        userId: userId,
        fcmToken: newToken,
        language: language,
      );
    });
  }

  Future<void> _configureIosPresentationOptions() async {
    if (!Platform.isIOS) return;
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<AndroidNotificationChannel> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      FirebaseConstants.highImportanceChannelId,
      FirebaseConstants.highImportanceChannelName,
      description: FirebaseConstants.highImportanceChannelDescription,
      importance: Importance.max,
    );
    final androidPlugin = localNotifs
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(channel);
    return channel;
  }

  void _listenToForegroundMessages(AndroidNotificationChannel channel) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message, channel);
      _storeInMemory(message);
      log('Foreground message: ${message.messageId}');
    });
  }

  void _showLocalNotification(
    RemoteMessage message,
    AndroidNotificationChannel channel,
  ) {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification == null || android == null) return;
    localNotifs.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _storeInMemory(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    getIt<NotificationService>().addNotification(
      NotificationModel(
        id: message.messageId ?? DateTime.now().toIso8601String(),
        title: notification.title ?? '',
        body: notification.body ?? '',
        receivedAt: DateTime.now(),
        isRead: false,
      ),
    );
  }

  void _registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  void _handleNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('App opened from notification: ${message.messageId}');
    });
  }

  Future<void> _handleLaunchFromNotification() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      log('App launched from notification: ${initialMessage.messageId}');
    }
  }
}
