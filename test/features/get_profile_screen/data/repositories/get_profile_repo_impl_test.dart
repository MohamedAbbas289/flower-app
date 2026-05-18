
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/get_profile_screen/data/data_sources/profile_remote_data_source_contract.dart';
import 'package:flower_app/features/get_profile_screen/data/models/get_user_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_repo_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSourceContract])
void main () {
  late ProfileRemoteDataSourceContract profileRemoteDataSourceContract;

  setUpAll(() {
    provideDummy<ProfileRemoteDataSourceContract>(
      MockProfileRemoteDataSourceContract(),
    );
    provideDummy<BaseResponse<GetUserDto>>(
      SuccessBaseResponse<GetUserDto>(data: GetUserDto()),
    );
    provideDummy<BaseResponse<GetUserDto>>(
      ErrorBaseResponse<GetUserDto>(exception: Exception()),
    );
    provideDummy<BaseResponse<GetUserDto>>(
      SuccessBaseResponse<GetUserDto>(data: GetUserDto(
        id: '1',
        firstName: 'test',
        lastName: 'test',
        email: 'test',
        password: 'test',
        gender: 'test',
        phone: 'test',
        photo: 'test',
        role: 'test',
      )),
    );

  });
  setUp(() {
    profileRemoteDataSourceContract = MockProfileRemoteDataSourceContract();
  });
  group('Get Profile Data Test Group ', () {
    test(
        'Test Success Case With Empty Data (No Products DTos Returned)  ', () async {
      when(profileRemoteDataSourceContract.getProfileData()).thenAnswer((
          _) async => SuccessBaseResponse<GetUserDto>(data: GetUserDto()));
      final result = await profileRemoteDataSourceContract.getProfileData();
      expect(result, isA<SuccessBaseResponse<GetUserDto>>());
      expect((result as SuccessBaseResponse<GetUserDto>).data, isNotNull);
    });

    test('Test Error Case With Exception ', () async {
      when(profileRemoteDataSourceContract.getProfileData()).thenAnswer((
          _) async => ErrorBaseResponse<GetUserDto>(exception: Exception()));
      final result = await profileRemoteDataSourceContract.getProfileData();
      expect(result, isA<ErrorBaseResponse<GetUserDto>>());
    });
    test('Test Success Case With Data ', () async {
      when(profileRemoteDataSourceContract.getProfileData()).thenAnswer((
          _) async => SuccessBaseResponse<GetUserDto>(data: GetUserDto()));
      final result = await profileRemoteDataSourceContract.getProfileData();
      expect(result, isA<SuccessBaseResponse<GetUserDto>>());
      expect((result as SuccessBaseResponse<GetUserDto>).data, isNotNull);
    });
  });
}
