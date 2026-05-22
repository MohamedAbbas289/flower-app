import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/edit_profile/data/data_sources/edit_profile_data_source_contract.dart';
import 'package:flower_app/features/edit_profile/data/models/edit_user_dto.dart';
import 'package:flower_app/features/edit_profile/data/repositories/edit_profile_repo_impl.dart';
import 'package:flower_app/features/edit_profile/domain/entities/edit_user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_profile_repo_impl_test.mocks.dart';

@GenerateMocks([EditProfileDataSourceContract])
void main() {
  late MockEditProfileDataSourceContract editProfileDataSourceContract;
  late EditProfileRepoImpl editProfileRepoImpl;

  final request = EditUserDto(
    firstName: 'Ahmed',
    lastName: 'Ali',
    email: 'ahmed@test.com',
    phone: '+201000000000',
  );

  setUpAll(() {
    provideDummy<BaseResponse<EditUserDto>>(
      SuccessBaseResponse<EditUserDto>(data: EditUserDto()),
    );
    provideDummy<BaseResponse<EditUserDto>>(
      ErrorBaseResponse<EditUserDto>(exception: Exception()),
    );
  });

  setUp(() {
    editProfileDataSourceContract = MockEditProfileDataSourceContract();
    editProfileRepoImpl = EditProfileRepoImpl(editProfileDataSourceContract);
  });

  group('EditProfileRepoImpl', () {
    test('returns success entity when datasource succeeds', () async {
      final dto = EditUserDto(
        id: '1',
        firstName: 'Ahmed',
        lastName: 'Ali',
        email: 'ahmed@test.com',
        gender: 'male',
        phone: '+201000000000',
        photo: 'photo.png',
        role: 'user',
      );

      when(
        editProfileDataSourceContract.editProfile(request: request),
      ).thenAnswer((_) async => SuccessBaseResponse<EditUserDto>(data: dto));

      final result = await editProfileRepoImpl.editProfile(request: request);

      expect(result, isA<SuccessBaseResponse<EditUserEntity>>());
      final entity = (result as SuccessBaseResponse<EditUserEntity>).data;
      expect(entity.id, dto.id);
      expect(entity.firstName, dto.firstName);
      expect(entity.lastName, dto.lastName);
      expect(entity.email, dto.email);
      expect(entity.gender, dto.gender);
      expect(entity.phone, dto.phone);
      expect(entity.photo, dto.photo);
      verify(editProfileDataSourceContract.editProfile(request: request))
          .called(1);
      verifyNoMoreInteractions(editProfileDataSourceContract);
    });

    test('returns error response when datasource fails', () async {
      final exception = Exception();

      when(
        editProfileDataSourceContract.editProfile(request: request),
      ).thenAnswer(
        (_) async => ErrorBaseResponse<EditUserDto>(exception: exception),
      );

      final result = await editProfileRepoImpl.editProfile(request: request);

      expect(result, isA<ErrorBaseResponse<EditUserEntity>>());
      expect((result as ErrorBaseResponse<EditUserEntity>).exception, exception);
      verify(editProfileDataSourceContract.editProfile(request: request))
          .called(1);
      verifyNoMoreInteractions(editProfileDataSourceContract);
    });
  });
}
