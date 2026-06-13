import 'package:flower_app/config/base_response/base_response.dart';
import '../../../add_address/domain/entities/address_entity.dart';

abstract interface class SavedAddressRepoContract {
  Future<BaseResponse<List<AddressEntity>>> getAddresses();
  Future<BaseResponse<bool>> deleteAddress(String id);
}