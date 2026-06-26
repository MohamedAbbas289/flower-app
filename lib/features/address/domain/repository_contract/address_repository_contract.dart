import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

abstract interface class AddressRepositoryContract {
  Future<BaseResponse<List<AddressEntity>>> addNewAddress({
    required AddAddressRequestModel request,
  });

  Future<BaseResponse<List<AddressEntity>>> editAddress({
    required String id,
    required AddAddressRequestModel request,
  });

  Future<BaseResponse<List<AddressEntity>>> getAddresses();

  Future<BaseResponse<bool>> deleteAddress(String id);
}
