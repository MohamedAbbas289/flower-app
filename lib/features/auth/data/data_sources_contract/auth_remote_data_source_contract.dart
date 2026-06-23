import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/auth/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/auth/domain/entities/forget_password_entity.dart';

abstract interface class AuthRemoteDataSourceContract {
  Future<AuthResponse> login({required String email, required String password});

  Future<void> logout();

  Future<BaseResponse<AuthResponse>> signup({
    required SignupRequestModel requestModel,
  });

  Future<BaseResponse<ForgetPasswordEntity>> forgotPassword(String email);

  Future<BaseResponse<ForgetPasswordEntity>> verifyCode(String code);

  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  });
}
