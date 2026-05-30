
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/add_address_repo_contract.dart';
import '../data_sources/add_address_data_source_contract.dart';
import '../models/add_address_dto.dart';


@Injectable(as: AddAddressRepoContract)
class AddAddressRepoImpl implements AddAddressRepoContract {
  final AddAddressDataSourceContract addAddressDataSourceContract;

  AddAddressRepoImpl(this.addAddressDataSourceContract);

  @override
  Future<BaseResponse<List<AddressEntity>>> addNewAddress({
    String? token,
    required AddAddressDto request,
  }) async {
    final response = await addAddressDataSourceContract.addNewAddress(
      token: token,
      request: request,
    );
    switch (response) {
      case SuccessBaseResponse<List<AddAddressDto>>():
        return SuccessBaseResponse<List<AddressEntity>>(
          data: response.data.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<List<AddAddressDto>>():
        return ErrorBaseResponse<List<AddressEntity>>(exception: response.exception);
    }
  }
}
