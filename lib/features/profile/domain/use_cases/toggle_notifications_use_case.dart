import 'package:flower_app/features/profile/domain/repository_contract/profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ToggleNotificationsUseCase {
  final ProfileRepoContract _repo;

  ToggleNotificationsUseCase(this._repo);

  Future<void> execute(bool value, String languageCode) async {
    await _repo.toggleNotifications(value, languageCode);
  }
}
