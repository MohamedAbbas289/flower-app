import 'package:flower_app/features/profile/domain/repository_contract/profile_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateLanguageUseCase {
  final ProfileRepoContract _repo;

  UpdateLanguageUseCase(this._repo);

  Future<void> execute(String languageCode) async {
    await _repo.updateLanguage(languageCode);
  }
}
