import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';
import 'package:flower_app/features/edit_address/data/data_sources_contract/edit_address_remote_data_source_contract.dart';
import 'package:flower_app/features/edit_address/data/models/edit_address_response.dart';
import 'package:flower_app/features/edit_address/domain/repositories_contract/edit_address_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: EditAddressRepoContract)
class EditAddressRepoImpl implements EditAddressRepoContract {
  final EditAddressRemoteDataSourceContract _dataSource;

  EditAddressRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<List<AddressEntity>>> editAddress({
    required String id,
    required AddAddressDto request,
  }) async {
    final response = await _dataSource.editAddress(id: id, request: request);

    switch (response) {
      case SuccessBaseResponse<EditAddressResponse>():
        final addresses = response.data.addresses;

        if (addresses == null) {
          return ErrorBaseResponse<List<AddressEntity>>(
            exception: Exception(AppStrings.somethingWentWrong),
          );
        }

        return SuccessBaseResponse<List<AddressEntity>>(
          data: addresses.map((e) => e.toDomain()).toList(),
        );

      case ErrorBaseResponse<EditAddressResponse>():
        return ErrorBaseResponse<List<AddressEntity>>(
          exception: response.exception,
        );
    }
  }
}
