import 'package:flower_app/features/profile/domain/repository_contract/profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetNotificationsEnabledUseCase {
  final ProfileRepoContract _repo;

  GetNotificationsEnabledUseCase(this._repo);

  Future<bool> execute() async {
    return await _repo.getNotificationsEnabled();
  }
}
