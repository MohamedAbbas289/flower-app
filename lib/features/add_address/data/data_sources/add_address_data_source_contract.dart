import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';

abstract interface class AddAddressDataSourceContract {
  Future<BaseResponse<List<AddAddressDto>>> addNewAddress({
    required AddAddressDto request,
  });
}