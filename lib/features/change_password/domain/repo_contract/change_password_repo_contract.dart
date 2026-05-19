import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/change_password/domain/entity/change_password_entity.dart';

abstract interface class ChangePasswordRepoContract {
  Future<BaseResponse<ChangePasswordEntity>> changePassword({
    required String password,
    required String newPassword,
  });
}
