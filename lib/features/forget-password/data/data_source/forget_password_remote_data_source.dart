import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';

/// Contract for the forget-password remote data operations.
/// The implementation lives in [ForgetPasswordRemoteDataSourceImpl].
abstract interface class ForgetPasswordRemoteDataSource {
  Future<BaseResponse<ForgetPasswordEntity>> forgotPassword(String email);

  Future<BaseResponse<ForgetPasswordEntity>> verifyCode(String code);

  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  });
}
