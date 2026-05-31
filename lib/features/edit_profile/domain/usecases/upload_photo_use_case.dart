import 'dart:io';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/edit_profile/domain/repositories_contract/edit_profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadPhotoUseCase {
  final EditProfileRepoContract _editProfileRepoContract;

  UploadPhotoUseCase(this._editProfileRepoContract);

  Future<BaseResponse<void>> call(File photo) async {
    return await _editProfileRepoContract.uploadPhoto(photo);
  }
}
