import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/change_password/data/data_source_contract/change_password_remote_data_source_contract.dart';
import 'package:flower_app/features/change_password/data/model/change_password_response.dart';
import 'package:flower_app/features/change_password/data/repo_impl/change_password_repo_impl.dart';
import 'package:flower_app/features/change_password/domain/entity/change_password_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'change_password_repo_impl_test.mocks.dart';

@GenerateMocks([ChangePasswordRemoteDataSourceContract])
void main() {
  late ChangePasswordRepoImpl repo;
  late MockChangePasswordRemoteDataSourceContract mockDataSource;

  final tResponse = ChangePasswordResponse(
    message: 'Password changed successfully',
    token: 'new_token_123',
  );

  setUpAll(() {
    provideDummy<BaseResponse<ChangePasswordResponse>>(
      SuccessBaseResponse<ChangePasswordResponse>(data: tResponse),
    );
    provideDummy<BaseResponse<ChangePasswordResponse>>(
      ErrorBaseResponse<ChangePasswordResponse>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockDataSource = MockChangePasswordRemoteDataSourceContract();
    repo = ChangePasswordRepoImpl(mockDataSource);
  });

  group('changePassword', () {
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
        (_) async => ErrorBaseResponse(exception: Exception('network error')),
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
}
