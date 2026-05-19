
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../../../core/values/api_param.dart';
import '../../../../core/values/endpoints.dart';
import '../../data/models/edit_profile_response.dart';
import '../../data/models/edit_user_dto.dart';
part 'edit_profile_api_client.g.dart';

@injectable
@RestApi()
abstract class EditProfileApiClient {
  @factoryMethod
  factory EditProfileApiClient(Dio dio) = _EditProfileApiClient;


  @PUT(Endpoints.editProfile)
  Future<EditProfileResponse> updateProfile({
    @Header(ApiParam.token) String? token,
    @Body() required EditUserDto request,
  });




}
