
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage (RemoteMessage message)async {
  log('handleBackgroundMessage: $message');
  final notification = message.notification;
  if (notification == null) return;

  final android = notification.android;
  if (android == null) return;

  log('title: ${notification.title}');
  log('body: ${notification.body}');
  log('channelId: ${android.channelId}');

  final data = message.data;
  if (data.isNotEmpty) {
    log('data: $data');
  }
}

class FirebaseApi {
 final  _firebaseMessaging = FirebaseMessaging.instance ;
 Future <void> initNotification () async {
   try {
     await _firebaseMessaging.requestPermission();
     final fcmToken = await _firebaseMessaging.getToken();
     log('fcmToken: $fcmToken');
     
     // Set foreground notification presentation options for iOS
     await _firebaseMessaging.setForegroundNotificationPresentationOptions(
       alert: true,
       badge: true,
       sound: true,
     );

     // Listen to foreground messages for debugging and processing
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       log('Received foreground message: ${message.messageId}');
       if (message.notification != null) {
         log('Foreground Notification Title: ${message.notification?.title}');
         log('Foreground Notification Body: ${message.notification?.body}');
       }
     });

     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
   } catch (e, stack) {
     log('Error initializing Firebase Notifications: $e', stackTrace: stack);
   }
 }
}
