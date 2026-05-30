import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../data/models/add_address_dto.dart';
import '../entities/address_entity.dart';
import '../repositories/add_address_repo_contract.dart';

@injectable

class AddAddressUseCases {
  final AddAddressRepoContract addAddressRepoContract;
  AddAddressUseCases(this.addAddressRepoContract);
  Future<BaseResponse<List<AddressEntity>>> call(
    AddAddressDto request,
  ) async {
    return await addAddressRepoContract.addNewAddress(
      request: request,
    );
  }
}

