import 'package:dio/dio.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/change_password/api/request_models/change_password_request_model.dart';
import 'package:flower_app/features/change_password/data/model/change_password_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'change_password_api_client.g.dart';
@lazySingleton
@RestApi()
abstract interface class ChangePasswordApiClient {
  @factoryMethod
  factory ChangePasswordApiClient(Dio dio) => _ChangePasswordApiClient(dio);

  @PATCH(Endpoints.changePassword)
  Future<ChangePasswordResponse> changePassword({
    @Body() required ChangePasswordRequestModel changePasswordRequestModel,
  });
}
