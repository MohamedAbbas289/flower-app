import 'dart:io';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/profile/domain/repository_contract/profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadPhotoUseCase {
  final ProfileRepoContract _profileRepoContract;

  UploadPhotoUseCase(this._profileRepoContract);

  Future<BaseResponse<void>> call(File photo) async {
    return await _profileRepoContract.uploadPhoto(photo);
  }
}
