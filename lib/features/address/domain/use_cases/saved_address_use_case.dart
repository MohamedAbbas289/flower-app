import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/saved_address/domain/repositories_contract/saved_address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAddressesUseCase {
  final SavedAddressRepoContract _repo;

  GetAddressesUseCase(this._repo);

  Future<BaseResponse<List<AddressEntity>>> call() async {
    return await _repo.getAddresses();
  }
}
