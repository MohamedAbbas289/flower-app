import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flower_app/features/address/data/models/edit_address_response.dart';
import 'package:flower_app/features/address/data/models/get_addresses_response.dart';

abstract interface class AddressRemoteDataSourceContract {
  Future<BaseResponse<List<AddAddressDto>>> addNewAddress({
    required AddAddressRequestModel request,
  });

  Future<BaseResponse<EditAddressResponse>> editAddress({
    required String id,
    required AddAddressRequestModel request,
  });

  Future<BaseResponse<GetAddressesResponse>> getAddresses();

  Future<BaseResponse<bool>> deleteAddress(String id);
}
