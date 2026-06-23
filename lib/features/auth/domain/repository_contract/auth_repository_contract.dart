import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/auth/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/auth/domain/entities/forget_password_entity.dart';

abstract interface class AuthRepositoryContract {
  Future<BaseResponse<AuthResponseEntity>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<BaseResponse<void>> logout();

  Future<BaseResponse<AuthResponseEntity>> signup({
    required SignupRequestModel requestModel,
  });

  Future<BaseResponse<ForgetPasswordEntity>> forgotPassword(String email);

  Future<BaseResponse<ForgetPasswordEntity>> verifyCode(String code);

  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  });
}
