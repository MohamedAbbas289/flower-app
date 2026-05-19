import 'dart:async';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/edit_profile/data/data_sources/edit_profile_data_source_contract.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/edit_user_dto.dart';
import '../edit_profile_api_client/edit_profile_api_client.dart';
@Injectable(as: EditProfileDataSourceImpl)
class EditProfileDataSourceImpl implements EditProfileDataSourceContract{
  final EditProfileApiClient editProfileApiClient;
  EditProfileDataSourceImpl(this.editProfileApiClient);
  @override
  Future<BaseResponse<EditUserDto>> editProfile() async {
    try {
      final response = await editProfileApiClient.updateProfile(request: EditUserDto());
      return SuccessBaseResponse<EditUserDto>(
        data: response.user!,
      );
    } catch (e) {
      return ErrorBaseResponse<EditUserDto>(exception: e);
    }
  }
}


