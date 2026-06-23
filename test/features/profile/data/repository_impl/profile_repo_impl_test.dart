import 'dart:io';

import 'package:flower_app/config/base_response/base_response.dart';
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

@GenerateMocks([ProfileRemoteDataSourceContract])
void main() {
  late MockProfileRemoteDataSourceContract mockDataSource;
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
    repo = ProfileRepoImpl(mockDataSource);
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
  });
}
