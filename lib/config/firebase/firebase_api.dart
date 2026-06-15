import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level function for background message handling.
// Must be annotated with @pragma('vm:entry-point') so it is not tree-shaken.
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

final FlutterLocalNotificationsPlugin localNotifs = FlutterLocalNotificationsPlugin();

/// Initializes Local Notifications configuration for Android and iOS.
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

  /// Initializes FCM settings, requests permissions, gets the token, and configures listeners.
  Future<void> initNotification() async {
    try {
      // 1. Request Notification Permission (Required for iOS and Android 13+)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      log('User notification permission status: ${settings.authorizationStatus}');

      // 2. Fetch and Log FCM Registration Token
      if (Platform.isIOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();

        if (apnsToken == null) {
          log('APNS token not ready yet, retry later');
          return ;
        }
        log('APNS token ready: $apnsToken');
      }

      final fcmToken = await _firebaseMessaging.getToken();

      /// 4. Token refresh listener
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        log('🔄 Token Refreshed: $newToken');

        /// send to backend here
      });
      log('====================================================');
      log('FCM REGISTRATION TOKEN:');
      log('$fcmToken');
      log('====================================================');







      // 3. Initialize Local Notifications
      await initLocalNotifications();

      // 4. Configure Foreground Notification Presentation (iOS only)
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );


      // 5. Configure Android High Importance Channel for heads-up notifications
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.max,
      );

      final AndroidFlutterLocalNotificationsPlugin? androidPlatformChannelSpecifics =
          localNotifs.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlatformChannelSpecifics != null) {
        await androidPlatformChannelSpecifics.createNotificationChannel(channel);
      }

      // 6. Listen to Foreground Messages (when app is open)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('--- Foreground Message Received ---');
        log('Message ID: ${message.messageId}');

        final RemoteNotification? notification = message.notification;
        final AndroidNotification? android = message.notification?.android;

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

        if (message.data.isNotEmpty) {
          log('Data Payload: ${message.data}');
        }
        log('------------------------------------');
      });

      // 7. Handle Background/Terminated Message Event (when app runs in background)
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // 8. Handle App Opened from Background Notification (when user clicks notification banner)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('--- App Opened from Background Notification ---');
        log('Message ID: ${message.messageId}');
        if (message.notification != null) {
          log('Title: ${message.notification?.title}');
        }
        log('Data Payload: ${message.data}');
        log('------------------------------------');
      });

      // 9. Handle App Opened from Terminated State via Notification
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        log('--- App Launched from Terminated Notification ---');
        log('Message ID: ${initialMessage.messageId}');
        if (initialMessage.notification != null) {
          log('Title: ${initialMessage.notification?.title}');
        }
        log('Data Payload: ${initialMessage.data}');
        log('------------------------------------');
      }

    } catch (e, stack) {
      log('❌ Firebase Notification Error: $e', stackTrace: stack);
    }
  }
}