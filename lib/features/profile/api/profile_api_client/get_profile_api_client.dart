import 'package:dio/dio.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/values/endpoints.dart';

part 'get_profile_api_client.g.dart';

@injectable
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET(Endpoints.getProfile)
  Future<AuthResponse> getProfileData();
}
