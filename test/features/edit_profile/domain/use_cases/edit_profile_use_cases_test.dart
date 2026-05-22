import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/edit_profile/data/models/edit_user_dto.dart';
import 'package:flower_app/features/edit_profile/domain/entities/edit_user_entity.dart';
import 'package:flower_app/features/edit_profile/domain/repositories/edit_profile_repo_contract.dart';
import 'package:flower_app/features/edit_profile/domain/use_cases/edit_profile_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_use_cases_test.mocks.dart';

@GenerateMocks([EditProfileRepoContract])
void main() {
  late MockEditProfileRepoContract editProfileRepoContract;
  late EditProfileUseCases editProfileUseCases;

  final request = EditUserDto(
    firstName: 'Ahmed',
    lastName: 'Ali',
    email: 'ahmed@test.com',
    phone: '+201000000000',
  );

  setUpAll(() {
    provideDummy<BaseResponse<EditUserEntity>>(
      SuccessBaseResponse<EditUserEntity>(data: const EditUserEntity()),
    );
    provideDummy<BaseResponse<EditUserEntity>>(
      ErrorBaseResponse<EditUserEntity>(exception: Exception()),
    );
  });

  setUp(() {
    editProfileRepoContract = MockEditProfileRepoContract();
    editProfileUseCases = EditProfileUseCases(editProfileRepoContract);
  });

  group('EditProfileUseCases', () {
    test('returns success response when repository succeeds', () async {
      const entity = EditUserEntity(
        id: '1',
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@test.com',
        phone: '+201000000000',
      );
      final response = SuccessBaseResponse<EditUserEntity>(data: entity);

      when(
        editProfileRepoContract.editProfile(request: request),
      ).thenAnswer((_) async => response);

      final result = await editProfileUseCases(request);

      expect(result, isA<SuccessBaseResponse<EditUserEntity>>());
      expect((result as SuccessBaseResponse<EditUserEntity>).data, entity);
      verify(editProfileRepoContract.editProfile(request: request)).called(1);
      verifyNoMoreInteractions(editProfileRepoContract);
    });

    test('returns error response when repository fails', () async {
      final exception = Exception();
      final response = ErrorBaseResponse<EditUserEntity>(exception: exception);

      when(
        editProfileRepoContract.editProfile(request: request),
      ).thenAnswer((_) async => response);

      final result = await editProfileUseCases(request);

      expect(result, isA<ErrorBaseResponse<EditUserEntity>>());
      expect((result as ErrorBaseResponse<EditUserEntity>).exception, exception);
      verify(editProfileRepoContract.editProfile(request: request)).called(1);
      verifyNoMoreInteractions(editProfileRepoContract);
    });
  });
}
