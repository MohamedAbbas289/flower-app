import 'dart:io';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/models/user_model.dart';
import 'package:flower_app/features/edit_profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/edit_profile/data/datasources_contract/edit_profile_remote_data_source_contract.dart';
import 'package:flower_app/features/edit_profile/data/repositories_impl/edit_profile_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_repo_impl_test.mocks.dart';

@GenerateMocks([EditProfileRemoteDataSourceContract])
void main() {
  late MockEditProfileRemoteDataSourceContract mockDataSource;
  late EditProfileRepoImpl repo;

  final tRequest = EditProfileRequestModel(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '01012345678',
  );

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
    mockDataSource = MockEditProfileRemoteDataSourceContract();
    repo = EditProfileRepoImpl(mockDataSource);
    provideDummy<BaseResponse<AuthResponse>>(
      SuccessBaseResponse<AuthResponse>(data: tAuthResponse),
    );
    provideDummy<BaseResponse<void>>(
      SuccessBaseResponse<void>(data: null),
    );
  });

  group('EditProfileRepoImpl', () {
    group('editProfile', () {
      test('should return SuccessBaseResponse with entity when data source succeeds', () async {
        when(mockDataSource.editProfile(tRequest))
            .thenAnswer((_) async => SuccessBaseResponse<AuthResponse>(data: tAuthResponse));

        final result = await repo.editProfile(tRequest);

        expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
        expect((result as SuccessBaseResponse<AuthResponseEntity>).data.message, equals('success'));
        expect(result.data.token, equals('test_token'));
        verify(mockDataSource.editProfile(tRequest)).called(1);
      });

      test('should return ErrorBaseResponse when data source fails', () async {
        when(mockDataSource.editProfile(tRequest))
            .thenAnswer((_) async => ErrorBaseResponse<AuthResponse>(exception: Exception('error')));

        final result = await repo.editProfile(tRequest);

        expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
        verify(mockDataSource.editProfile(tRequest)).called(1);
      });
    });

    group('uploadPhoto', () {
      test('should return SuccessBaseResponse when upload succeeds', () async {
        final tFile = File('assets/images/app_icon.png');
        when(mockDataSource.uploadPhoto(tFile))
            .thenAnswer((_) async => SuccessBaseResponse<void>(data: null));

        final result = await repo.uploadPhoto(tFile);

        expect(result, isA<SuccessBaseResponse<void>>());
        verify(mockDataSource.uploadPhoto(tFile)).called(1);
      });

      test('should return ErrorBaseResponse when upload fails', () async {
        final tFile = File('assets/images/app_icon.png');
        when(mockDataSource.uploadPhoto(tFile))
            .thenAnswer((_) async => ErrorBaseResponse<void>(exception: Exception('error')));

        final result = await repo.uploadPhoto(tFile);

        expect(result, isA<ErrorBaseResponse<void>>());
        verify(mockDataSource.uploadPhoto(tFile)).called(1);
      });
    });
  });
}