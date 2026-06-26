import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';
import 'package:flower_app/features/address/data/data_sources_contract/address_remote_data_source_contract.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flower_app/features/address/data/models/edit_address_response.dart';
import 'package:flower_app/features/address/data/models/get_addresses_response.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/mappers/address_mapper.dart';
import 'package:flower_app/features/address/domain/repository_contract/address_repository_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRepositoryContract)
class AddressRepositoryImpl implements AddressRepositoryContract {
  final AddressRemoteDataSourceContract addressRemoteDataSourceContract;

  AddressRepositoryImpl(this.addressRemoteDataSourceContract);

  @override
  Future<BaseResponse<List<AddressEntity>>> addNewAddress({
    required AddAddressRequestModel request,
  }) async {
    final response = await addressRemoteDataSourceContract.addNewAddress(
      request: request,
    );
    switch (response) {
      case SuccessBaseResponse<List<AddAddressDto>>():
        return SuccessBaseResponse<List<AddressEntity>>(
          data: response.data.map((e) => e.toEntity()).toList(),
        );
      case ErrorBaseResponse<List<AddAddressDto>>():
        return ErrorBaseResponse<List<AddressEntity>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> editAddress({
    required String id,
    required AddAddressRequestModel request,
  }) async {
    final response = await addressRemoteDataSourceContract.editAddress(
      id: id,
      request: request,
    );

    switch (response) {
      case SuccessBaseResponse<EditAddressResponse>():
        final addresses = response.data.addresses;

        if (addresses == null) {
          return ErrorBaseResponse<List<AddressEntity>>(
            exception: Exception(AppStrings.somethingWentWrong),
          );
        }

        return SuccessBaseResponse<List<AddressEntity>>(
          data: addresses.map((e) => e.toEntity()).toList(),
        );

      case ErrorBaseResponse<EditAddressResponse>():
        return ErrorBaseResponse<List<AddressEntity>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<List<AddressEntity>>> getAddresses() async {
    final response = await addressRemoteDataSourceContract.getAddresses();

    switch (response) {
      case SuccessBaseResponse<GetAddressesResponse>():
        final addresses = response.data.addresses;

        if (addresses == null) {
          return ErrorBaseResponse<List<AddressEntity>>(
            exception: Exception(AppStrings.somethingWentWrong),
          );
        }

        return SuccessBaseResponse<List<AddressEntity>>(
          data: addresses.map((e) => e.toEntity()).toList(),
        );

      case ErrorBaseResponse<GetAddressesResponse>():
        return ErrorBaseResponse<List<AddressEntity>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<bool>> deleteAddress(String id) async {
    final response = await addressRemoteDataSourceContract.deleteAddress(id);

    switch (response) {
      case SuccessBaseResponse<bool>():
        return SuccessBaseResponse<bool>(data: true);

      case ErrorBaseResponse<bool>():
        return ErrorBaseResponse<bool>(exception: response.exception);
    }
  }
}
