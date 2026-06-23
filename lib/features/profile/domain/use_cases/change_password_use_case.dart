import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flower_app/features/profile/domain/repository_contract/profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordUseCase {
  final ProfileRepoContract _profileRepoContract;

  ChangePasswordUseCase(this._profileRepoContract);

  Future<BaseResponse<ChangePasswordEntity>> changePassword({
    required String password,
    required String newPassword,
  }) {
    return _profileRepoContract.changePassword(
      password: password,
      newPassword: newPassword,
    );
  }
}
