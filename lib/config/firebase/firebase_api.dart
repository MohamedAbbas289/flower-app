import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/core/values/firebase_constants.dart';
import 'package:flower_app/features/home/data/models/notification_model.dart';
import 'package:flower_app/features/home/data/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      log('Notification permission: ${settings.authorizationStatus}');

      if (Platform.isIOS) {
        try {
          final apnsToken = await FirebaseMessaging.instance
              .getAPNSToken()
              .timeout(const Duration(seconds: 5));

          if (apnsToken == null) {
            log('⚠️ iOS Push Notifications: Not available for now (APNs not configured)');
            return;
          }
          log('APNs token ready: $apnsToken');
        } catch (_) {
          log('⚠️ iOS Push Notifications: Not available for now');
          return;
        }
      }

      final fcmToken = await _firebaseMessaging.getToken();
      log('FCM token retrieved: ${fcmToken != null}');

      if (fcmToken != null) {
        final authManager = getIt<AuthManager>();
        final userId = authManager.userId;
        if (userId != null && userId.isNotEmpty) {
          final rawLang = PlatformDispatcher.instance.locale.languageCode;
          final language = rawLang == 'ar' ? 'ar' : 'en';
          await getIt<FirestoreService>().saveUserFcmData(
            userId: userId,
            fcmToken: fcmToken,
            language: language,
          );
        }
      }

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        final authManager = getIt<AuthManager>();
        final userId = authManager.userId;
        if (userId != null && userId.isNotEmpty) {
          final rawLang = PlatformDispatcher.instance.locale.languageCode;
          final language = rawLang == 'ar' ? 'ar' : 'en';
          getIt<FirestoreService>().saveUserFcmData(
            userId: userId,
            fcmToken: newToken,
            language: language,
          );
        }
      });

      await initLocalNotifications();

      if (Platform.isIOS) {
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
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

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        final android = message.notification?.android;

        if (notification != null && android != null) {
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
        if (notification != null) {
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
        log('Foreground message: ${message.messageId}');
      });

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('App opened from notification: ${message.messageId}');
      });

      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        log('App launched from notification: ${initialMessage.messageId}');
      }
    } catch (e, stack) {
      log('❌ FCM init failed: $e', stackTrace: stack);
    }
  }
}
