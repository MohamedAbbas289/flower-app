import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/saved_address/data/data_sources_contract/saved_address_remote_data_source_contract.dart';
import 'package:flower_app/features/saved_address/data/models/get_addresses_response.dart';
import 'package:flower_app/features/saved_address/domain/repositories_contract/saved_address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SavedAddressRepoContract)
class SavedAddressRepoImpl implements SavedAddressRepoContract {
  final SavedAddressDataSourceContract _dataSource;

  SavedAddressRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<List<AddressEntity>>> getAddresses() async {
    final response = await _dataSource.getAddresses();

    switch (response) {
      case SuccessBaseResponse<GetAddressesResponse>():
        final addresses = response.data.addresses;

        if (addresses == null) {
          return ErrorBaseResponse<List<AddressEntity>>(
            exception: Exception(AppStrings.somethingWentWrong),
          );
        }

        return SuccessBaseResponse<List<AddressEntity>>(
          data: addresses.map((e) => e.toDomain()).toList(),
        );

      case ErrorBaseResponse<GetAddressesResponse>():
        return ErrorBaseResponse<List<AddressEntity>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<bool>> deleteAddress(String id) async {
    final response = await _dataSource.deleteAddress(id);

    switch (response) {
      case SuccessBaseResponse<bool>():
        return SuccessBaseResponse<bool>(data: true);

      case ErrorBaseResponse<bool>():
        return ErrorBaseResponse<bool>(exception: response.exception);
    }
  }
}
