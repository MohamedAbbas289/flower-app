import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/saved_address/data/models/get_addresses_response.dart';

abstract interface class SavedAddressDataSourceContract {
  Future<BaseResponse<GetAddressesResponse>> getAddresses();
  Future<BaseResponse<bool>> deleteAddress(String id);
}