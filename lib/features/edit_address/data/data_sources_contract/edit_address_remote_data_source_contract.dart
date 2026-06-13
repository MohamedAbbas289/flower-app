import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/edit_address/data/models/edit_address_response.dart';

abstract interface class EditAddressRemoteDataSourceContract {
  Future<BaseResponse<EditAddressResponse>> editAddress({
    required String id,
    required AddAddressDto request,
  });
}
