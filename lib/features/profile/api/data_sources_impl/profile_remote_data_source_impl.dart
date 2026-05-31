import 'dart:async';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../../data/data_sources_contract/profile_remote_data_source_contract.dart';
import '../profile_api_client/get_profile_api_client.dart';

@Injectable(as: ProfileRemoteDataSourceContract)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSourceContract {
  final ProfileApiClient profileApiClient;

  ProfileRemoteDataSourceImpl(this.profileApiClient);

  @override
  Future<BaseResponse<AuthResponse>> getProfileData() async {
    try {
      final response = await profileApiClient.getProfileData();
      return SuccessBaseResponse<AuthResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<AuthResponse>(exception: e);
    }
  }
}
