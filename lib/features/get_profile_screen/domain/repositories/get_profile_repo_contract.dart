
import '../../../../config/base_response/base_response.dart';
import '../entities/user_entitiy.dart';


abstract interface class GetProfileRepoContract {
  Future <BaseResponse<GetUserEntity>> getProfileData() ;


}
