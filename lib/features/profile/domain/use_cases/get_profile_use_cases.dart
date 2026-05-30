import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:injectable/injectable.dart';
import '../../../../config/base_response/base_response.dart';
import '../repository_contract/get_profile_repo_contract.dart';

@injectable
class GetProfileUseCases {
  final GetProfileRepoContract getProfileRepoContract;
  GetProfileUseCases(this.getProfileRepoContract);

  Future<BaseResponse<AuthResponseEntity>> call() async {
    return await getProfileRepoContract.getProfileData();
  }
}
