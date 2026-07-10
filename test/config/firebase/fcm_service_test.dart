import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/firebase/fcm_service.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/config/local_notifications/local_notifications_service.dart';
import 'package:flower_app/config/secure_storage/secure_storage_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fcm_service_test.mocks.dart';

const _tSettings = NotificationSettings(
  alert: AppleNotificationSetting.enabled,
  announcement: AppleNotificationSetting.disabled,
  authorizationStatus: AuthorizationStatus.authorized,
  badge: AppleNotificationSetting.enabled,
  carPlay: AppleNotificationSetting.disabled,
  lockScreen: AppleNotificationSetting.enabled,
  notificationCenter: AppleNotificationSetting.enabled,
  showPreviews: AppleShowPreviewSetting.always,
  timeSensitive: AppleNotificationSetting.disabled,
  criticalAlert: AppleNotificationSetting.disabled,
  sound: AppleNotificationSetting.enabled,
  providesAppNotificationSettings: AppleNotificationSetting.disabled,
);

const _tChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
);

@GenerateMocks([
  FirebaseMessaging,
  LocalNotificationsService,
  FirestoreService,
  AuthManager,
  SecureStorageService,
])
void main() {
  late MockFirebaseMessaging mockMessaging;
  late MockLocalNotificationsService mockLocalNotificationsService;
  late MockFirestoreService mockFirestoreService;
  late MockAuthManager mockAuthManager;
  late MockSecureStorageService mockStorageService;
  late FcmService service;

  setUp(() {
    mockMessaging = MockFirebaseMessaging();
    mockLocalNotificationsService = MockLocalNotificationsService();
    mockFirestoreService = MockFirestoreService();
    mockAuthManager = MockAuthManager();
    mockStorageService = MockSecureStorageService();
    service = FcmService(
      mockMessaging,
      mockFirestoreService,
      mockAuthManager,
      mockStorageService,
      mockLocalNotificationsService,
    );
  });

  group('getFcmToken', () {
    test('delegates to messaging.getToken', () async {
      when(mockMessaging.getToken()).thenAnswer((_) async => 'token_1');

      final result = await service.getFcmToken();

      expect(result, 'token_1');
      verify(mockMessaging.getToken()).called(1);
    });
  });

  group('deleteToken', () {
    test('delegates to messaging.deleteToken', () async {
      when(mockMessaging.deleteToken()).thenAnswer((_) async {});

      await service.deleteToken();

      verify(mockMessaging.deleteToken()).called(1);
    });
  });

  group('saveFcmDataForUser', () {
    test('delegates to firestoreService.saveUserFcmData', () async {
      when(
        mockFirestoreService.saveUserFcmData(
          userId: anyNamed('userId'),
          fcmToken: anyNamed('fcmToken'),
          language: anyNamed('language'),
        ),
      ).thenAnswer((_) async {});

      await service.saveFcmDataForUser(
        userId: 'user_1',
        fcmToken: 'token_1',
        language: 'en',
      );

      verify(
        mockFirestoreService.saveUserFcmData(
          userId: 'user_1',
          fcmToken: 'token_1',
          language: 'en',
        ),
      ).called(1);
    });
  });

  group('initNotification', () {
    test(
      'requests permission and saves fcm data when authManager has a userId',
      () async {
        when(
          mockMessaging.requestPermission(
            alert: anyNamed('alert'),
            announcement: anyNamed('announcement'),
            badge: anyNamed('badge'),
            carPlay: anyNamed('carPlay'),
            criticalAlert: anyNamed('criticalAlert'),
            provisional: anyNamed('provisional'),
            sound: anyNamed('sound'),
          ),
        ).thenAnswer((_) async => _tSettings);
        when(mockMessaging.getToken()).thenAnswer((_) async => 'token_1');
        when(mockAuthManager.userId).thenReturn('user_1');
        when(mockStorageService.readLanguage()).thenAnswer((_) async => 'en');
        when(
          mockFirestoreService.saveUserFcmData(
            userId: anyNamed('userId'),
            fcmToken: anyNamed('fcmToken'),
            language: anyNamed('language'),
          ),
        ).thenAnswer((_) async {});
        when(mockMessaging.onTokenRefresh)
            .thenAnswer((_) => const Stream.empty());
        when(mockLocalNotificationsService.initialize())
            .thenAnswer((_) async {});
        when(mockLocalNotificationsService.createAndroidChannel())
            .thenAnswer((_) async => _tChannel);
        when(mockMessaging.getInitialMessage())
            .thenAnswer((_) async => null);

        await service.initNotification();

        verify(
          mockMessaging.requestPermission(
            alert: anyNamed('alert'),
            announcement: anyNamed('announcement'),
            badge: anyNamed('badge'),
            carPlay: anyNamed('carPlay'),
            criticalAlert: anyNamed('criticalAlert'),
            provisional: anyNamed('provisional'),
            sound: anyNamed('sound'),
          ),
        ).called(1);
        verify(
          mockFirestoreService.saveUserFcmData(
            userId: 'user_1',
            fcmToken: 'token_1',
            language: 'en',
          ),
        ).called(1);
        verify(mockLocalNotificationsService.initialize()).called(1);
      },
    );

    test('skips fcm data save when authManager has no userId', () async {
      when(
        mockMessaging.requestPermission(
          alert: anyNamed('alert'),
          announcement: anyNamed('announcement'),
          badge: anyNamed('badge'),
          carPlay: anyNamed('carPlay'),
          criticalAlert: anyNamed('criticalAlert'),
          provisional: anyNamed('provisional'),
          sound: anyNamed('sound'),
        ),
      ).thenAnswer((_) async => _tSettings);
      when(mockMessaging.getToken()).thenAnswer((_) async => 'token_1');
      when(mockAuthManager.userId).thenReturn(null);
      when(mockMessaging.onTokenRefresh)
          .thenAnswer((_) => const Stream.empty());
      when(mockLocalNotificationsService.initialize())
          .thenAnswer((_) async {});
      when(mockLocalNotificationsService.createAndroidChannel())
          .thenAnswer((_) async => _tChannel);
      when(mockMessaging.getInitialMessage()).thenAnswer((_) async => null);

      await service.initNotification();

      verifyNever(
        mockFirestoreService.saveUserFcmData(
          userId: anyNamed('userId'),
          fcmToken: anyNamed('fcmToken'),
          language: anyNamed('language'),
        ),
      );
      verify(mockLocalNotificationsService.initialize()).called(1);
    });
  });
}
