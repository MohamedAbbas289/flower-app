import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/address/data/data_sources_contract/address_remote_data_source_contract.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flower_app/features/address/data/models/edit_address_response.dart';
import 'package:flower_app/features/address/data/models/get_addresses_response.dart';
import 'package:injectable/injectable.dart';

import '../api_client/address_api_client.dart';

@Injectable(as: AddressRemoteDataSourceContract)
class AddressRemoteDataSourceImpl implements AddressRemoteDataSourceContract {
  final AddressApiClient _addressApiClient;

  AddressRemoteDataSourceImpl(this._addressApiClient);

  @override
  Future<BaseResponse<List<AddAddressDto>>> addNewAddress({
    required AddAddressDto request,
  }) async {
    try {
      final response = await _addressApiClient.addNewAddress(
        request: request,
      );

      final address = response.address;

      if (address == null) {
        return ErrorBaseResponse<List<AddAddressDto>>(
          exception: Exception(AppStrings.addressMissingOrNull),
        );
      }

      return SuccessBaseResponse<List<AddAddressDto>>(data: address);
    } catch (e) {
      return ErrorBaseResponse<List<AddAddressDto>>(exception: e);
    }
  }

  @override
  Future<BaseResponse<EditAddressResponse>> editAddress({
    required String id,
    required AddAddressDto request,
  }) async {
    try {
      final response = await _addressApiClient.editAddress(
        id: id,
        request: request,
      );
      return SuccessBaseResponse<EditAddressResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<EditAddressResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<GetAddressesResponse>> getAddresses() async {
    try {
      final response = await _addressApiClient.getAddresses();
      return SuccessBaseResponse<GetAddressesResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<GetAddressesResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<bool>> deleteAddress(String id) async {
    try {
      await _addressApiClient.deleteAddress(id);
      return SuccessBaseResponse<bool>(data: true);
    } catch (e) {
      return ErrorBaseResponse<bool>(exception: e);
    }
  }
}
