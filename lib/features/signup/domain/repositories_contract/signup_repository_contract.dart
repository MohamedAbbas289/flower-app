import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/signup/api/request_models/signup_request_model.dart';

abstract interface class SignupRepositoryContract {
  Future<BaseResponse<AuthResponseEntity>> signup({
    required SignupRequestModel requestModel,
  });
}
