import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/repository_contract/address_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAddressesUseCase {
  final AddressRepositoryContract _repo;

  GetAddressesUseCase(this._repo);

  Future<BaseResponse<List<AddressEntity>>> call() async {
    return await _repo.getAddresses();
  }
}
