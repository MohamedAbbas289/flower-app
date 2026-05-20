import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/get_profile_screen/data/data_sources/profile_remote_data_source_contract.dart';
import 'package:flower_app/features/get_profile_screen/data/models/get_user_dto.dart';
import 'package:flower_app/features/get_profile_screen/data/repositories/get_profile_repo_impl.dart';
import 'package:flower_app/features/get_profile_screen/domain/entities/user_entitiy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_repo_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSourceContract])
void main() {
  late ProfileRemoteDataSourceContract profileRemoteDataSourceContract;
  late ProfileRepoImpl profileRepoImpl;

  setUpAll(() {
    provideDummy<BaseResponse<GetUserDto>>(
      SuccessBaseResponse<GetUserDto>(data: GetUserDto()),
    );
    provideDummy<BaseResponse<GetUserDto>>(
      ErrorBaseResponse<GetUserDto>(exception: Exception()),
    );
  });

  setUp(() {
    profileRemoteDataSourceContract = MockProfileRemoteDataSourceContract();
    profileRepoImpl = ProfileRepoImpl(profileRemoteDataSourceContract);
  });

  group('Get Profile Data Test Group ', () {
    test('Test Success Case With Empty Data', () async {
      when(profileRemoteDataSourceContract.getProfileData()).thenAnswer(
        (_) async => SuccessBaseResponse<GetUserDto>(data: GetUserDto()),
      );

      final result = await profileRepoImpl.getProfileData();

      expect(result, isA<SuccessBaseResponse<GetUserEntity>>());
      expect((result as SuccessBaseResponse<GetUserEntity>).data, isNotNull);
      verify(profileRemoteDataSourceContract.getProfileData()).called(1);
    });

    test('Test Error Case With Exception ', () async {
      final exception = Exception();
      when(profileRemoteDataSourceContract.getProfileData()).thenAnswer(
        (_) async => ErrorBaseResponse<GetUserDto>(exception: exception),
      );

      final result = await profileRepoImpl.getProfileData();

      expect(result, isA<ErrorBaseResponse<GetUserEntity>>());
      expect((result as ErrorBaseResponse<GetUserEntity>).exception, exception);
      verify(profileRemoteDataSourceContract.getProfileData()).called(1);
    });

    test('Test Success Case With Data ', () async {
      final dto = GetUserDto(
        id: '1',
        firstName: 'test',
        lastName: 'user',
        email: 'test@example.com',
        password: 'password',
        gender: 'male',
        phone: '01000000000',
        photo: 'photo.png',
        role: 'user',
      );
      when(
        profileRemoteDataSourceContract.getProfileData(),
      ).thenAnswer((_) async => SuccessBaseResponse<GetUserDto>(data: dto));

      final result = await profileRepoImpl.getProfileData();

      expect(result, isA<SuccessBaseResponse<GetUserEntity>>());
      final entity = (result as SuccessBaseResponse<GetUserEntity>).data;
      expect(entity.id, dto.id);
      expect(entity.firstName, dto.firstName);
      expect(entity.lastName, dto.lastName);
      expect(entity.email, dto.email);
      expect(entity.phone, dto.phone);
      verify(profileRemoteDataSourceContract.getProfileData()).called(1);
    });
  });
}
