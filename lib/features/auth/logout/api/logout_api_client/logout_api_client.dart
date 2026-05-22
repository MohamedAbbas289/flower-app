import 'package:dio/dio.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'logout_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class LogoutApiClient {
  @factoryMethod
  factory LogoutApiClient(Dio dio) = _LogoutApiClient;

  @POST(Endpoints.logout)
  Future<void> logout();
}
