import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';

abstract interface class EditAddressRepoContract {
  Future<BaseResponse<List<AddressEntity>>> editAddress({
    required String id,
    required AddAddressDto request,
  });
}