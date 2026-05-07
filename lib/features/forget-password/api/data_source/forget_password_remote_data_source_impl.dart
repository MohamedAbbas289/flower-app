import 'package:flower_app/features/forget-password/data/data_source/forget_password_remote_data_source.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ForgetPasswordRemoteDataSource)
class ForgetPasswordRemoteDataSourceImpl
    implements ForgetPasswordRemoteDataSource {
  @override
  Future<ForgetPasswordEntity> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    return ForgetPasswordEntity(
      forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forgotPassword,
      message: "Success",
      info: "Code sent to your email",
    );
  }

  @override
  Future<ForgetPasswordEntity> verifyCode(String code) async {
    await Future.delayed(const Duration(seconds: 1));

    if (code == "123456") {
      return ForgetPasswordEntity(
        forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.verifyCode,
        status: "Success",
        message: "Code verified successfully",
      );
    }

    return ForgetPasswordEntity(
      forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.verifyCode,
      status: "Error",
      message: "Invalid code",
    );
  }

  @override
  Future<ForgetPasswordEntity> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return ForgetPasswordEntity(
      forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.resetPassword,
      status: "Success",
      message: "Password changed successfully",
    );
  }
}
