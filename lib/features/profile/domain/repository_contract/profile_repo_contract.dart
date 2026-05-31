import 'package:flower_app/core/entities/auth_response_entity.dart';
import '../../../../config/base_response/base_response.dart';


abstract interface class ProfileRepoContract {
  Future <BaseResponse<AuthResponseEntity>> getProfileData() ;


}
