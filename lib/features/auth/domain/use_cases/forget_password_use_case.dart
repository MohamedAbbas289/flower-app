import 'package:flower_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../entities/forget_password_entity.dart';
import '../repository_contract/auth_repository_contract.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthRepositoryContract repository;

  ForgetPasswordUseCase(this.repository);

  Future<BaseResponse<ForgetPasswordEntity>> forgotPassword(String email) {
    return repository.forgotPassword(email);
  }

  Future<BaseResponse<ForgetPasswordEntity>> verifyCode(String code) {
    return repository.verifyCode(code);
  }

  Future<BaseResponse<ForgetPasswordEntity>> resetPassword({
    required String email,
    required String newPassword,
  }) {
    return repository.resetPassword(email: email, newPassword: newPassword);
  }
}
