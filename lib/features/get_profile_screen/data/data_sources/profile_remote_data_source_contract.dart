



import '../../../../config/base_response/base_response.dart';
import '../models/get_user_dto.dart';

abstract interface class ProfileRemoteDataSourceContract {

  Future<BaseResponse<GetUserDto>> getProfileData();

}
