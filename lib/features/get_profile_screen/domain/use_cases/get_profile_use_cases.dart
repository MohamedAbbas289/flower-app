import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/user_entitiy.dart';
import '../repositories/get_profile_repo_contract.dart';
@injectable
class GetProfileUseCases {

  final GetProfileRepoContract getProfileRepoContract ;
  GetProfileUseCases(this.getProfileRepoContract);

  Future<BaseResponse<GetUserEntity>> call () async {
    return  await getProfileRepoContract.getProfileData();
  }


}
