import 'package:flower_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_source/forget_password_remote_data_source.dart';
import '../../domain/entities/forget_password_entity.dart';

@Injectable(as: ForgetPasswordRemoteDataSource)
class ForgetPasswordRemoteDataSourceImpl
    implements ForgetPasswordRemoteDataSource {
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
