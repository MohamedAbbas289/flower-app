import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/profile/domain/repository_contract/edit_profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditProfileUseCase {
  final EditProfileRepoContract _editProfileRepoContract;

  EditProfileUseCase(this._editProfileRepoContract);

  Future<BaseResponse<AuthResponseEntity>> call(
    EditProfileRequestModel request,
  ) async {
    return await _editProfileRepoContract.editProfile(request);
  }
}
