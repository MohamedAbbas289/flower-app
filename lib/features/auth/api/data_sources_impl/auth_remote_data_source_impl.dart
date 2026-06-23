import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/features/auth/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:injectable/injectable.dart';
import '../../data/data_sources_contract/auth_remote_data_source_contract.dart';
import '../api_client/auth_api_client.dart';

@Injectable(as: AuthRemoteDataSourceContract)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return _authApiClient.login({
      ApiParam.email: email,
      ApiParam.password: password,
    });
  }

  @override
  Future<void> logout() {
    return _authApiClient.logout();
  }

  @override
  Future<BaseResponse<AuthResponse>> signup({
    required SignupRequestModel requestModel,
  }) async {
    try {
      final response = await _authApiClient.signup(
        requestModel: requestModel,
      );
      return SuccessBaseResponse<AuthResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<AuthResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> forgotPassword(
    String email,
  ) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      return SuccessBaseResponse(
        data: ForgetPasswordEntity(
          forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forgotPassword,
          message: "Success",
          info: "Code sent to your email",
        ),
      );
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> verifyCode(String code) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (code == "1234") {
        return SuccessBaseResponse(
          data: ForgetPasswordEntity(
            forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.verifyCode,
            status: "Success",
            message: "Code verified successfully",
          ),
        );
      }

      return ErrorBaseResponse(exception: Exception("Invalid code"));
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      return SuccessBaseResponse(
        data: ForgetPasswordEntity(
          forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.resetPassword,
          status: "Success",
          message: "Password changed successfully",
        ),
      );
    } on Exception catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }
}
