
import '../../../../config/base_response/base_response.dart';
import '../models/add_address_dto.dart';

abstract interface class AddAddressDataSourceContract {
  Future<BaseResponse<List<AddAddressDto>>> addNewAddress({
    String? token,
    required AddAddressDto request,
  });
}
