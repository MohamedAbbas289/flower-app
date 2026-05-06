import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';

abstract class ForgetPasswordRemoteDataSource {
  Future<ForgetPasswordEntity> forgotPassword(String email);
  Future<ForgetPasswordEntity> verifyCode(String code);
  Future<ForgetPasswordEntity> resetPassword({
    required String email,
    required String newPassword,
  });
}
