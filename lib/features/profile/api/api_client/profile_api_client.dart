import 'package:dio/dio.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/profile/api/request_models/change_password_request_model.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/profile/data/models/change_password_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api_client.g.dart';

@lazySingleton
@RestApi()
abstract interface class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET(Endpoints.getProfile)
  Future<AuthResponse> getProfileData();

  @PUT(Endpoints.editProfile)
  Future<AuthResponse> editProfile(@Body() EditProfileRequestModel request);

  @PUT(Endpoints.uploadPhoto)
  @MultiPart()
  Future<void> uploadPhoto(@Part(name: ApiParam.photo) MultipartFile photo);

  @PATCH(Endpoints.changePassword)
  Future<ChangePasswordResponse> changePassword({
    @Body() required ChangePasswordRequestModel changePasswordRequestModel,
  });
}
