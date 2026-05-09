import 'package:dio/dio.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/signup/api/request_models/signup_request_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'signup_api_client.g.dart';

@lazySingleton
@RestApi()
abstract interface class SignupApiClient {
  @factoryMethod
  factory SignupApiClient(Dio dio) => _SignupApiClient(dio);

  @POST(Endpoints.signup)
  @Extra({ApiParam.requiresAuth: false})
  Future<AuthResponse> signup({
    @Body() required SignupRequestModel requestModel,
  });
}
