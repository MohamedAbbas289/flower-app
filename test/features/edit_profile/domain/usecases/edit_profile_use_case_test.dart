import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/edit_profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/edit_profile/domain/repositories_contract/edit_profile_repo_contract.dart';
import 'package:flower_app/features/edit_profile/domain/usecases/edit_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_use_case_test.mocks.dart';

@GenerateMocks([EditProfileRepoContract])
void main() {
  late MockEditProfileRepoContract mockRepo;
  late EditProfileUseCase useCase;

  final tRequest = EditProfileRequestModel(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '01012345678',
  );

  final tAuthResponseEntity = AuthResponseEntity(
    message: 'success',
    token: 'test_token',
    user: null,
  );

  setUp(() {
    mockRepo = MockEditProfileRepoContract();
    useCase = EditProfileUseCase(mockRepo);
    provideDummy<BaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse<AuthResponseEntity>(data: tAuthResponseEntity),
    );
  });

  group('EditProfileUseCase', () {
    test('should return SuccessBaseResponse when repo succeeds', () async {
      when(mockRepo.editProfile(tRequest))
          .thenAnswer((_) async => SuccessBaseResponse<AuthResponseEntity>(data: tAuthResponseEntity));

      final result = await useCase(tRequest);

      expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
      expect((result as SuccessBaseResponse<AuthResponseEntity>).data.message, equals('success'));
      expect(result.data.token, equals('test_token'));
      verify(mockRepo.editProfile(tRequest)).called(1);
    });

    test('should return ErrorBaseResponse when repo fails', () async {
      when(mockRepo.editProfile(tRequest))
          .thenAnswer((_) async => ErrorBaseResponse<AuthResponseEntity>(exception: Exception('error')));

      final result = await useCase(tRequest);

      expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
      verify(mockRepo.editProfile(tRequest)).called(1);
    });
  });
}