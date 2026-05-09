import 'package:dio/dio.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'login_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class LoginApiClient {
  @factoryMethod
  factory LoginApiClient(Dio dio) = _LoginApiClient;

  @POST(Endpoints.signin)
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);
}
