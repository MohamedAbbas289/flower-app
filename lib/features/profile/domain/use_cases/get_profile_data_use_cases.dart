import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../repository_contract/profile_repo_contract.dart';

@injectable
class GetProfileDataUseCases {
  final ProfileRepoContract profileRepoContract;
  GetProfileDataUseCases(this.profileRepoContract);

  Future<BaseResponse<AuthResponseEntity>> call() async {
    return await profileRepoContract.getProfileData();
  }
}
