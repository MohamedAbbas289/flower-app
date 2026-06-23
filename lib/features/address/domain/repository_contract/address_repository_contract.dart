import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

abstract interface class AddressRepositoryContract {
  Future<BaseResponse<List<AddressEntity>>> addNewAddress({
    required AddAddressDto request,
  });

  Future<BaseResponse<List<AddressEntity>>> editAddress({
    required String id,
    required AddAddressDto request,
  });

  Future<BaseResponse<List<AddressEntity>>> getAddresses();

  Future<BaseResponse<bool>> deleteAddress(String id);
}
