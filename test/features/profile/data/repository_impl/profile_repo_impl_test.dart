import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/models/user_model.dart';
import 'package:flower_app/features/profile/data/data_sources_contract/profile_remote_data_source_contract.dart';
import 'package:flower_app/features/profile/data/repository_impl/profile_repo_impl.dart';
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

  final testAuthResponse = AuthResponse(
    message: 'success',
    token: 'test_token',
    user: tUser,
  );

  setUp(() {
    mockDataSource = MockProfileRemoteDataSourceContract();
    repo = ProfileRepoImpl(mockDataSource);
    provideDummy<BaseResponse<AuthResponse>>(
      SuccessBaseResponse<AuthResponse>(data: testAuthResponse),
    );
  });

  group('ProfileRepoImpl', () {
    test(
      'should return SuccessBaseResponse with entity when data source succeeds',
      () async {
        when(mockDataSource.getProfileData()).thenAnswer(
          (_) async =>
              SuccessBaseResponse<AuthResponse>(data: testAuthResponse),
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
}
