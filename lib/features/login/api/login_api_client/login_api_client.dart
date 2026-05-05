import 'package:dio/dio.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/login/api/responses/login_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'login_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class LoginApiClient {
  @factoryMethod
  factory LoginApiClient(Dio dio) = _LoginApiClient;

  /// Authenticates the user with email and password.
  ///
  /// No auth token is required for this endpoint. The [AuthInterceptor] only
  /// attaches a token when one is already present in [AuthManager], so calling
  /// this before login is always safe even without explicitly disabling auth.
  @POST(Endpoints.signin)
  Future<LoginResponse> login(@Body() Map<String, dynamic> body);
}
