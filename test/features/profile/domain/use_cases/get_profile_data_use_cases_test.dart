import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/profile/domain/repository_contract/profile_repo_contract.dart';
import 'package:flower_app/features/profile/domain/use_cases/get_profile_data_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_data_use_cases_test.mocks.dart';

@GenerateMocks([ProfileRepoContract])
void main() {
  late MockProfileRepoContract mockRepo;
  late GetProfileDataUseCases useCase;

  final tAuthResponseEntity = AuthResponseEntity(
    message: 'success',
    token: 'test_token',
    user: null,
  );

  setUp(() {
    mockRepo = MockProfileRepoContract();
    useCase = GetProfileDataUseCases(mockRepo);
    provideDummy<BaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse<AuthResponseEntity>(data: tAuthResponseEntity),
    );
  });

  group('GetProfileDataUseCases', () {
    test('should return SuccessBaseResponse when repo succeeds', () async {
      when(mockRepo.getProfileData())
          .thenAnswer((_) async => SuccessBaseResponse<AuthResponseEntity>(data: tAuthResponseEntity));

      final result = await useCase();

      expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
      expect((result as SuccessBaseResponse<AuthResponseEntity>).data.message, equals('success'));
      expect(result.data.token, equals('test_token'));
      verify(mockRepo.getProfileData()).called(1);
    });

    test('should return ErrorBaseResponse when repo fails', () async {
      when(mockRepo.getProfileData())
          .thenAnswer((_) async => ErrorBaseResponse<AuthResponseEntity>(exception: Exception('error')));

      final result = await useCase();

      expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
      verify(mockRepo.getProfileData()).called(1);
    });
  });
}