import 'package:flower_app/features/edit_profile/data/models/edit_user_dto.dart';

import '../../../../config/base_response/base_response.dart';


abstract interface class EditProfileDataSourceContract {

  Future<BaseResponse<EditUserDto>> editProfile();


}