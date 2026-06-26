import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../api/request_models/add_address_request_model.dart';
import '../entities/address_entity.dart';
import '../repository_contract/address_repository_contract.dart';

@injectable
class AddAddressUseCase {
  final AddressRepositoryContract _addressRepositoryContract;
  AddAddressUseCase(this._addressRepositoryContract);
  Future<BaseResponse<List<AddressEntity>>> execute({
    required AddAddressRequestModel request,
  }) async {
    return await _addressRepositoryContract.addNewAddress(request: request);
  }
}
