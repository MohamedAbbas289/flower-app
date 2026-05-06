import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/signup/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/signup/domain/entities/auth_response_entity.dart';

abstract interface class SignupRepositoryContract {
  Future<BaseResponse<AuthResponseEntity>> signup({
    required SignupRequestModel requestModel,
  });
}
