import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../data/models/add_address_dto.dart';
import '../entities/address_entity.dart';
import '../repository_contract/address_repository_contract.dart';

@injectable
class AddAddressUseCases {
  final AddressRepositoryContract _addressRepositoryContract;
  AddAddressUseCases(this._addressRepositoryContract);
  Future<BaseResponse<List<AddressEntity>>> call(AddAddressDto request) async {
    return await _addressRepositoryContract.addNewAddress(request: request);
  }
}
