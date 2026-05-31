import 'dart:io';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/edit_profile/api/datasources_impl/edit_profile_remote_data_source_impl.dart';
import 'package:flower_app/features/edit_profile/api/edit_profile_api_client/edit_profile_api_client.dart';
import 'package:flower_app/features/edit_profile/api/request_models/edit_profile_request_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([EditProfileApiClient])
void main() {
  late MockEditProfileApiClient mockApiClient;
  late EditProfileRemoteDataSourceImpl dataSource;

  final tRequest = EditProfileRequestModel(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '01012345678',
  );

  final tAuthResponse = AuthResponse(
    message: 'success',
    token: 'test_token',
    user: null,
  );

  setUp(() {
    mockApiClient = MockEditProfileApiClient();
    dataSource = EditProfileRemoteDataSourceImpl(mockApiClient);
    provideDummy<BaseResponse<AuthResponse>>(
      SuccessBaseResponse<AuthResponse>(data: tAuthResponse),
    );
    provideDummy<BaseResponse<void>>(SuccessBaseResponse<void>(data: null));
  });

  group('EditProfileRemoteDataSourceImpl', () {
    group('editProfile', () {
      test(
        'should return SuccessBaseResponse when API call succeeds',
        () async {
          when(
            mockApiClient.editProfile(tRequest),
          ).thenAnswer((_) async => tAuthResponse);

          final result = await dataSource.editProfile(tRequest);

          expect(result, isA<SuccessBaseResponse<AuthResponse>>());
          expect(
            (result as SuccessBaseResponse<AuthResponse>).data,
            equals(tAuthResponse),
          );
          verify(mockApiClient.editProfile(tRequest)).called(1);
        },
      );

      test(
        'should return ErrorBaseResponse when API call throws exception',
        () async {
          when(
            mockApiClient.editProfile(tRequest),
          ).thenThrow(Exception('Server error'));

          final result = await dataSource.editProfile(tRequest);

          expect(result, isA<ErrorBaseResponse<AuthResponse>>());
          verify(mockApiClient.editProfile(tRequest)).called(1);
        },
      );
    });

    group('uploadPhoto', () {
      test(
        'should return ErrorBaseResponse when file does not exist',
        () async {
          final tFile = File('non_existing_file.png');

          final result = await dataSource.uploadPhoto(tFile);

          expect(result, isA<ErrorBaseResponse<void>>());
          verifyNever(mockApiClient.uploadPhoto(any));
        },
      );

      test(
        'should return ErrorBaseResponse when upload API throws exception',
        () async {
          final tFile = await File(
            'assets/images/app_icon.png',
          ).create(recursive: true);
          when(
            mockApiClient.uploadPhoto(any),
          ).thenThrow(Exception('Upload error'));

          final result = await dataSource.uploadPhoto(tFile);

          expect(result, isA<ErrorBaseResponse<void>>());
          verify(mockApiClient.uploadPhoto(any)).called(1);

          await tFile.delete();
        },
      );
    });
  });
}
