import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/saved_address/domain/repositories_contract/saved_address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAddressUseCase {
  final SavedAddressRepoContract _repo;

  DeleteAddressUseCase(this._repo);

  Future<BaseResponse<void>> call(String id) async {
    return await _repo.deleteAddress(id);
  }
}