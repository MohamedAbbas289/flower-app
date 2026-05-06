import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/signup/api/request_models/signup_request_model.dart';

abstract interface class SignupRemoteDatasourceContract {
  Future<BaseResponse<AuthResponse>> signup({
    required SignupRequestModel requestModel,
  });
}
