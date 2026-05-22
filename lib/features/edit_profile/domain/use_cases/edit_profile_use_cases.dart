import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../entities/edit_user_entity.dart';
import '../repositories/edit_profile_repo_contract.dart';

@injectable
class EditProfileUseCases {

  final EditProfileRepoContract editProfileRepoContract ;
  EditProfileUseCases(this.editProfileRepoContract);

  Future<BaseResponse<EditUserEntity>> call () async {
    return  await editProfileRepoContract.editProfile();
  }


}
