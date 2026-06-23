import 'package:dio/dio.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../request_models/signup_request_model.dart';

part 'auth_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(Endpoints.signin)
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);

  @POST(Endpoints.logout)
  Future<void> logout();

  @POST(Endpoints.signup)
  @Extra({ApiParam.requiresAuth: false})
  Future<AuthResponse> signup({
    @Body() required SignupRequestModel requestModel,
  });
}
