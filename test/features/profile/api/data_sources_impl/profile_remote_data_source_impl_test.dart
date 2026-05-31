import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/profile/api/data_sources_impl/profile_remote_data_source_impl.dart';
import 'package:flower_app/features/profile/api/profile_api_client/get_profile_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])

void main() {
  late MockProfileApiClient mockProfileApiClient;
  late ProfileRemoteDataSourceImpl dataSource;

  setUp(() {
    mockProfileApiClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(mockProfileApiClient);
  });

  group('ProfileRemoteDataSourceImpl', () {
    final tAuthResponse = AuthResponse(
      message: 'success',
      token: 'test_token',
      user: null,
    );

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
}