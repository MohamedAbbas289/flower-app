
import '../../../../config/base_response/base_response.dart';
import '../../data/models/add_address_dto.dart';
import '../entities/address_entity.dart';

abstract interface class AddAddressRepoContract {
  Future<BaseResponse<List<AddressEntity>>> addNewAddress({
    required AddAddressDto request,
  });
}

