import 'dart:io';

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/profile/api/api_client/profile_api_client.dart';
import 'package:flower_app/features/profile/api/data_sources_impl/profile_remote_data_source_impl.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/profile/data/models/change_password_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  late MockProfileApiClient mockProfileApiClient;
  late ProfileRemoteDataSourceImpl dataSource;

  final tAuthResponse = AuthResponse(
    message: 'success',
    token: 'test_token',
    user: null,
  );

  setUp(() {
    mockProfileApiClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(mockProfileApiClient);
    provideDummy<BaseResponse<void>>(SuccessBaseResponse<void>(data: null));
  });

  group('ProfileRemoteDataSourceImpl', () {
    group('getProfileData', () {
      test(
        'should return SuccessBaseResponse when API call succeeds',
        () async {
          when(mockProfileApiClient.getProfileData())
              .thenAnswer((_) async => tAuthResponse);

          final result = await dataSource.getProfileData();

          expect(result, isA<SuccessBaseResponse<AuthResponse>>());
          expect(
            (result as SuccessBaseResponse<AuthResponse>).data,
            equals(tAuthResponse),
          );
          verify(mockProfileApiClient.getProfileData()).called(1);
        },
      );

      test(
        'should return ErrorBaseResponse when API call throws exception',
        () async {
          when(mockProfileApiClient.getProfileData())
              .thenThrow(Exception('Server error'));

          final result = await dataSource.getProfileData();

          expect(result, isA<ErrorBaseResponse<AuthResponse>>());
          verify(mockProfileApiClient.getProfileData()).called(1);
        },
      );
    });

    group('editProfile', () {
      final tRequest = EditProfileRequestModel(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '01012345678',
      );

      test(
        'should return SuccessBaseResponse when API call succeeds',
        () async {
          when(
            mockProfileApiClient.editProfile(tRequest),
          ).thenAnswer((_) async => tAuthResponse);

          final result = await dataSource.editProfile(tRequest);

          expect(result, isA<SuccessBaseResponse<AuthResponse>>());
          expect(
            (result as SuccessBaseResponse<AuthResponse>).data,
            equals(tAuthResponse),
          );
          verify(mockProfileApiClient.editProfile(tRequest)).called(1);
        },
      );

      test(
        'should return ErrorBaseResponse when API call throws exception',
        () async {
          when(
            mockProfileApiClient.editProfile(tRequest),
          ).thenThrow(Exception('Server error'));

          final result = await dataSource.editProfile(tRequest);

          expect(result, isA<ErrorBaseResponse<AuthResponse>>());
          verify(mockProfileApiClient.editProfile(tRequest)).called(1);
        },
      );
    });

    group('uploadPhoto', () {
      test(
        'should return ErrorBaseResponse when file does not exist',
        () async {
          final tFile = File(
            '${Directory.systemTemp.path}/profile_test_non_existing_file.png',
          );

          final result = await dataSource.uploadPhoto(tFile);

          expect(result, isA<ErrorBaseResponse<void>>());
          verifyNever(mockProfileApiClient.uploadPhoto(any));
        },
      );

      test(
        'should return ErrorBaseResponse when upload API throws exception',
        () async {
          final tFile = await File(
            '${Directory.systemTemp.path}/profile_test_upload_photo.png',
          ).create(recursive: true);
          when(
            mockProfileApiClient.uploadPhoto(any),
          ).thenThrow(Exception('Upload error'));

          final result = await dataSource.uploadPhoto(tFile);

          expect(result, isA<ErrorBaseResponse<void>>());
          verify(mockProfileApiClient.uploadPhoto(any)).called(1);

          await tFile.delete();
        },
      );
    });

    group('changePassword', () {
      final tResponse = ChangePasswordResponse(
        message: 'Password changed successfully',
        token: 'new_token_123',
      );

      test('returns SuccessBaseResponse on success', () async {
        when(
          mockProfileApiClient.changePassword(
            changePasswordRequestModel: anyNamed('changePasswordRequestModel'),
          ),
        ).thenAnswer((_) async => tResponse);

        final result = await dataSource.changePassword(
          password: 'OldPass@123',
          newPassword: 'NewPass@123',
        );

        expect(result, isA<SuccessBaseResponse<ChangePasswordResponse>>());
        final success = result as SuccessBaseResponse<ChangePasswordResponse>;
        expect(success.data.token, 'new_token_123');
      });

      test('returns ErrorBaseResponse on exception', () async {
        when(
          mockProfileApiClient.changePassword(
            changePasswordRequestModel: anyNamed('changePasswordRequestModel'),
          ),
        ).thenThrow(Exception('network error'));

        final result = await dataSource.changePassword(
          password: 'OldPass@123',
          newPassword: 'NewPass@123',
        );

        expect(result, isA<ErrorBaseResponse<ChangePasswordResponse>>());
        final error = result as ErrorBaseResponse<ChangePasswordResponse>;
        expect(error.errorMessage, isNotEmpty);
      });
    });
  });
}
