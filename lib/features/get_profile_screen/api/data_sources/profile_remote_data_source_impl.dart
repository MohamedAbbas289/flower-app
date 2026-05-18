import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../data/data_sources/profile_remote_data_source_contract.dart';
import '../../data/models/get_user_dto.dart';
import '../profile_api_client/get_profile_api_client.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient profileApiClient;

  ProfileRemoteDataSourceImpl(this.profileApiClient);

  @override
  Future<BaseResponse<GetUserDto>> getProfileData() async {
    try {
      final response = await profileApiClient.getProfileData();
      return SuccessBaseResponse<GetUserDto>(
        data: response.getUserDto!,
      );
    } catch (e) {
      return ErrorBaseResponse<GetUserDto>(exception: e);
    }
  }


}
