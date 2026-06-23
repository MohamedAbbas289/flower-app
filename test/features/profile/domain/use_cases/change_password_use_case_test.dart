import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flower_app/features/profile/domain/repository_contract/change_password_repo_contract.dart';
import 'package:flower_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'change_password_use_case_test.mocks.dart';

@GenerateMocks([ChangePasswordRepoContract])
void main() {
  late ChangePasswordUseCase useCase;
  late MockChangePasswordRepoContract mockRepo;

  final tEntity = ChangePasswordEntity(
    message: 'Password changed successfully',
    token: 'new_token_123',
  );

  setUpAll(() {
    provideDummy<BaseResponse<ChangePasswordEntity>>(
      SuccessBaseResponse<ChangePasswordEntity>(data: tEntity),
    );
    provideDummy<BaseResponse<ChangePasswordEntity>>(
      ErrorBaseResponse<ChangePasswordEntity>(exception: Exception('dummy')),
    );
  });

  setUp(() {
    mockRepo = MockChangePasswordRepoContract();
    useCase = ChangePasswordUseCase(mockRepo);
  });

  group('changePassword', () {
    test('delegates to repo and returns SuccessBaseResponse', () async {
      when(
        mockRepo.changePassword(
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

      final result = await useCase.changePassword(
        password: 'OldPass@123',
        newPassword: 'NewPass@123',
      );

      expect(result, isA<SuccessBaseResponse<ChangePasswordEntity>>());
      expect(
        (result as SuccessBaseResponse<ChangePasswordEntity>).data,
        tEntity,
      );
      verify(
        mockRepo.changePassword(
          password: 'OldPass@123',
          newPassword: 'NewPass@123',
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns ErrorBaseResponse when repo returns error', () async {
      when(
        mockRepo.changePassword(
          password: anyNamed('password'),
          newPassword: anyNamed('newPassword'),
        ),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception('error')),
      );

      final result = await useCase.changePassword(
        password: 'OldPass@123',
        newPassword: 'NewPass@123',
      );

      expect(result, isA<ErrorBaseResponse<ChangePasswordEntity>>());
      expect(
        (result as ErrorBaseResponse<ChangePasswordEntity>).errorMessage,
        isNotEmpty,
      );
    });
  });
}
