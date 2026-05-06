import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';

abstract class ForgetPasswordRepo {
  Future<BaseResponse<ForgetPasswordEntity>> forgotPassword(String email);

  Future<BaseResponse<ForgetPasswordEntity>> verifyCode(String code);

  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  });
}
