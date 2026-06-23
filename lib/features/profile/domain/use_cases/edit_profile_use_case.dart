import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flower_app/features/profile/domain/repository_contract/profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditProfileUseCase {
  final ProfileRepoContract _profileRepoContract;

  EditProfileUseCase(this._profileRepoContract);

  Future<BaseResponse<AuthResponseEntity>> call(
    EditProfileRequestModel request,
  ) async {
    return await _profileRepoContract.editProfile(request);
  }
}
