import 'package:dio/dio.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/edit_profile/api/request_models/edit_profile_request_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'edit_profile_api_client.g.dart';

@injectable
@RestApi()
abstract interface class EditProfileApiClient {
  @factoryMethod
  factory EditProfileApiClient(Dio dio) = _EditProfileApiClient;

  @PUT(Endpoints.editProfile)
  Future<AuthResponse> editProfile(@Body() EditProfileRequestModel request);

  @PUT(Endpoints.uploadPhoto)
  @MultiPart()
  Future<void> uploadPhoto(@Part(name: ApiParam.photo) MultipartFile photo);
}
