
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../../../core/values/endpoints.dart';
import '../../data/models/get_profile_response.dart';
import '../../data/models/get_user_dto.dart';
part 'profile_api_client.g.dart';
@injectable
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio,) = _ProfileApiClient;


  @GET(Endpoints.getProfile)
  Future<GetProfileResponse> getProfileData();

  @PUT(Endpoints.editProfile)
  Future<GetProfileResponse> updateProfile({
    @Body() required GetUserDto request,
  });


}
