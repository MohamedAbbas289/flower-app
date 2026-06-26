import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      // 1. Request Permission
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

      // 2. iOS: check APNs availability — skip gracefully if not configured
      if (Platform.isIOS) {
        try {
          final apnsToken = await FirebaseMessaging.instance
              .getAPNSToken()
              .timeout(const Duration(seconds: 5));

          if (apnsToken == null) {
            log(
              '⚠️ iOS Push Notifications: Not available for now (APNs not configured)',
            );
            return;
          }
          log('APNs token ready: $apnsToken');
        } catch (_) {
          log('⚠️ iOS Push Notifications: Not available for now');
          return;
        }
      }

      // 3. Get FCM Token
      final fcmToken = await _firebaseMessaging.getToken();
      log('====================================================');
      log('FCM TOKEN: $fcmToken');
      log('====================================================');

      // 4. Token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        log('🔄 FCM Token Refreshed: $newToken');
        // TODO: send to backend
      });

      // 5. Local Notifications init
      await initLocalNotifications();

      // 6. iOS foreground presentation (iOS only)
      if (Platform.isIOS) {
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      // 7. Android high importance channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

      final androidPlugin = localNotifs
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.createNotificationChannel(channel);

      // 8. Foreground messages
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
        log('Foreground message: ${message.messageId}');
      });

      // 9. Background messages
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // 10. App opened from background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('App opened from notification: ${message.messageId}');
      });

      // 11. App opened from terminated state
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        log('App launched from notification: ${initialMessage.messageId}');
      }
    } catch (e, stack) {
      log('❌ FCM init failed: $e', stackTrace: stack);
    }
  }
}
