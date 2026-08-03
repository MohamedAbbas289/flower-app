import 'dart:io';

import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/firebase/fcm_service.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/config/secure_storage/secure_storage_service.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/models/user_model.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:flower_app/features/profile/data/models/change_password_response.dart';
import 'package:flower_app/features/profile/data/repository_impl/profile_repo_impl.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repo_impl_test.mocks.dart';

@GenerateMocks([
  ProfileRemoteDataSourceContract,
  SecureStorageService,
  AuthManager,
  FirestoreService,
  FcmService,
])
void main() {
  late MockProfileRemoteDataSourceContract mockDataSource;
  late MockSecureStorageService mockStorageService;
  late MockAuthManager mockAuthManager;
  late MockFirestoreService mockFirestoreService;
  late MockFcmService mockFcmService;
  late ProfileRepoImpl repo;

  final tUser = User(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
  );

  final tAuthResponse = AuthResponse(
    message: 'success',
    token: 'test_token',
    user: tUser,
  );

  setUp(() {
    mockDataSource = MockProfileRemoteDataSourceContract();
    mockStorageService = MockSecureStorageService();
    mockAuthManager = MockAuthManager();
    mockFirestoreService = MockFirestoreService();
    mockFcmService = MockFcmService();
    repo = ProfileRepoImpl(
      mockDataSource,
      mockStorageService,
      mockAuthManager,
      mockFirestoreService,
      mockFcmService,
    );
    provideDummy<BaseResponse<AuthResponse>>(
      SuccessBaseResponse<AuthResponse>(data: tAuthResponse),
    );
    provideDummy<BaseResponse<void>>(SuccessBaseResponse<void>(data: null));
    provideDummy<BaseResponse<ChangePasswordResponse>>(
      ErrorBaseResponse<ChangePasswordResponse>(exception: Exception('dummy')),
    );
  });

  group('ProfileRepoImpl', () {
    group('getProfileData', () {
      test(
        'should return SuccessBaseResponse with entity when data source succeeds',
        () async {
          when(mockDataSource.getProfileData()).thenAnswer(
            (_) async =>
                SuccessBaseResponse<AuthResponse>(data: tAuthResponse),
          );

          final result = await repo.getProfileData();

          expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
          expect(
            (result as SuccessBaseResponse<AuthResponseEntity>).data.message,
            equals('success'),
          );
          expect(result.data.token, equals('test_token'));
          verify(mockDataSource.getProfileData()).called(1);
        },
      );

      test('should return ErrorBaseResponse when data source fails', () async {
        when(mockDataSource.getProfileData()).thenAnswer(
          (_) async =>
              ErrorBaseResponse<AuthResponse>(exception: Exception('error')),
        );

        final result = await repo.getProfileData();

        expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
        verify(mockDataSource.getProfileData()).called(1);
      });
    });

    group('editProfile', () {
      final tRequest = EditProfileRequestModel(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '01012345678',
      );

      test(
        'should return SuccessBaseResponse with entity when data source succeeds',
        () async {
          when(mockDataSource.editProfile(tRequest)).thenAnswer(
            (_) async =>
                SuccessBaseResponse<AuthResponse>(data: tAuthResponse),
          );

          final result = await repo.editProfile(tRequest);

          expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
          expect(
            (result as SuccessBaseResponse<AuthResponseEntity>).data.message,
            equals('success'),
          );
          expect(result.data.token, equals('test_token'));
          verify(mockDataSource.editProfile(tRequest)).called(1);
        },
      );

      test('should return ErrorBaseResponse when data source fails', () async {
        when(mockDataSource.editProfile(tRequest)).thenAnswer(
          (_) async =>
              ErrorBaseResponse<AuthResponse>(exception: Exception('error')),
        );

        final result = await repo.editProfile(tRequest);

        expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
        verify(mockDataSource.editProfile(tRequest)).called(1);
      });
    });

    group('uploadPhoto', () {
      final tFile = File(
        '${Directory.systemTemp.path}/profile_repo_test_photo.png',
      );

      test('should return SuccessBaseResponse when upload succeeds', () async {
        when(mockDataSource.uploadPhoto(tFile))
            .thenAnswer((_) async => SuccessBaseResponse<void>(data: null));

        final result = await repo.uploadPhoto(tFile);

        expect(result, isA<SuccessBaseResponse<void>>());
        verify(mockDataSource.uploadPhoto(tFile)).called(1);
      });

      test('should return ErrorBaseResponse when upload fails', () async {
        when(mockDataSource.uploadPhoto(tFile)).thenAnswer(
          (_) async => ErrorBaseResponse<void>(exception: Exception('error')),
        );

        final result = await repo.uploadPhoto(tFile);

        expect(result, isA<ErrorBaseResponse<void>>());
        verify(mockDataSource.uploadPhoto(tFile)).called(1);
      });
    });

    group('changePassword', () {
      final tResponse = ChangePasswordResponse(
        message: 'Password changed successfully',
        token: 'new_token_123',
      );

      test('returns SuccessBaseResponse with entity on success', () async {
        when(
          mockDataSource.changePassword(
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tResponse));

        final result = await repo.changePassword(
          password: 'OldPass@123',
          newPassword: 'NewPass@123',
        );

        expect(result, isA<SuccessBaseResponse<ChangePasswordEntity>>());
        final success = result as SuccessBaseResponse<ChangePasswordEntity>;
        expect(success.data.token, 'new_token_123');
      });

      test('returns ErrorBaseResponse on failure', () async {
        when(
          mockDataSource.changePassword(
            password: anyNamed('password'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer(
          (_) async =>
              ErrorBaseResponse(exception: Exception('network error')),
        );

        final result = await repo.changePassword(
          password: 'OldPass@123',
          newPassword: 'NewPass@123',
        );

        expect(result, isA<ErrorBaseResponse<ChangePasswordEntity>>());
        final error = result as ErrorBaseResponse<ChangePasswordEntity>;
        expect(error.errorMessage, isNotEmpty);
      });
    });

    group('updateLanguage', () {
      test('writes language and updates firestore when userId is present', () async {
        when(mockStorageService.writeLanguage('ar')).thenAnswer((_) async {});
        when(mockAuthManager.userId).thenReturn('user_1');
        when(
          mockFirestoreService.updateUserLanguage(
            userId: 'user_1',
            language: 'ar',
          ),
        ).thenAnswer((_) async {});

        await repo.updateLanguage('ar');

        verify(mockStorageService.writeLanguage('ar')).called(1);
        verify(
          mockFirestoreService.updateUserLanguage(
            userId: 'user_1',
            language: 'ar',
          ),
        ).called(1);
      });

      test('skips firestore update when userId is null', () async {
        when(mockStorageService.writeLanguage('ar')).thenAnswer((_) async {});
        when(mockAuthManager.userId).thenReturn(null);

        await repo.updateLanguage('ar');

        verify(mockStorageService.writeLanguage('ar')).called(1);
        verifyNever(
          mockFirestoreService.updateUserLanguage(
            userId: anyNamed('userId'),
            language: anyNamed('language'),
          ),
        );
      });
    });

    group('getNotificationsEnabled', () {
      test('returns value from storage', () async {
        when(mockStorageService.readNotificationsEnabled())
            .thenAnswer((_) async => false);

        final result = await repo.getNotificationsEnabled();

        expect(result, false);
      });
    });

    group('toggleNotifications', () {
      test('saves fcm data when enabling with valid userId and token', () async {
        when(mockStorageService.writeNotificationsEnabled(true))
            .thenAnswer((_) async {});
        when(mockStorageService.readUserId())
            .thenAnswer((_) async => 'user_1');
        when(mockFcmService.getFcmToken())
            .thenAnswer((_) async => 'token_1');
        when(
          mockFcmService.saveFcmDataForUser(
            userId: 'user_1',
            fcmToken: 'token_1',
            language: 'en',
          ),
        ).thenAnswer((_) async {});

        await repo.toggleNotifications(true, 'en');

        verify(mockStorageService.writeNotificationsEnabled(true)).called(1);
        verify(
          mockFcmService.saveFcmDataForUser(
            userId: 'user_1',
            fcmToken: 'token_1',
            language: 'en',
          ),
        ).called(1);
      });

      test('deletes token when disabling', () async {
        when(mockStorageService.writeNotificationsEnabled(false))
            .thenAnswer((_) async {});
        when(mockFcmService.deleteToken()).thenAnswer((_) async {});

        await repo.toggleNotifications(false, 'en');

        verify(mockStorageService.writeNotificationsEnabled(false)).called(1);
        verify(mockFcmService.deleteToken()).called(1);
      });
    });
  });
}
