import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/address/domain/repository_contract/address_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAddressUseCase {
  final AddressRepositoryContract _repo;

  DeleteAddressUseCase(this._repo);

  Future<BaseResponse<void>> call(String id) async {
    return await _repo.deleteAddress(id);
  }
}