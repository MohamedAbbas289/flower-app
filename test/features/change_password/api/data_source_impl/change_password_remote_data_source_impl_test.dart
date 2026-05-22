import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/change_password/api/api_client/change_password_api_client.dart';
import 'package:flower_app/features/change_password/api/data_source_impl/change_password_remote_data_source_impl.dart';
import 'package:flower_app/features/change_password/data/model/change_password_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'change_password_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ChangePasswordApiClient])
void main() {
  late ChangePasswordRemoteDataSourceImpl dataSource;
  late MockChangePasswordApiClient mockApiClient;

  final tResponse = ChangePasswordResponse(
    message: 'Password changed successfully',
    token: 'new_token_123',
  );

  setUp(() {
    mockApiClient = MockChangePasswordApiClient();
    dataSource = ChangePasswordRemoteDataSourceImpl(mockApiClient);
  });

  group('changePassword', () {
    test('returns SuccessBaseResponse on success', () async {
      when(
        mockApiClient.changePassword(
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
        mockApiClient.changePassword(
          changePasswordRequestModel: anyNamed('changePasswordRequestModel'),
        ),
      ).thenThrow(Exception('network error'));

      final result = await dataSource.changePassword(
        password: 'OldPass@123',
        newPassword: 'NewPass@123',
      );

      expect(result, isA<ErrorBaseResponse<ChangePasswordResponse>>());
    });
  });
  test('returns ErrorBaseResponse on exception', () async {
    when(
      mockApiClient.changePassword(
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
}
