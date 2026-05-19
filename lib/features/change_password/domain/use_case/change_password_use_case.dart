import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/change_password/domain/entity/change_password_entity.dart';
import 'package:flower_app/features/change_password/domain/repo_contract/change_password_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ChangePasswordRepoContract _changePasswordRepoContract;

  ChangePasswordUseCase(this._changePasswordRepoContract);

  Future<BaseResponse<ChangePasswordEntity>> changePassword({
    required String password,
    required String newPassword,
  }) {
    return _changePasswordRepoContract.changePassword(
      password: password,
      newPassword: newPassword,
    );
  }
}
