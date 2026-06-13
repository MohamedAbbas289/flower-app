import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flower_app/features/edit_address/data/data_sources_contract/edit_address_remote_data_source_contract.dart';
import 'package:flower_app/features/edit_address/data/models/edit_address_response.dart';
import 'package:injectable/injectable.dart';
import '../edit_address_api_client/edit_address_api_client.dart';

@Injectable(as: EditAddressRemoteDataSourceContract)
class EditAddressRemoteDataSourceImpl
    implements EditAddressRemoteDataSourceContract {
  final EditAddressApiClient _apiClient;

  EditAddressRemoteDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<EditAddressResponse>> editAddress({
    required String id,
    required AddAddressDto request,
  }) async {
    try {
      final response = await _apiClient.editAddress(id: id, request: request);
      return SuccessBaseResponse<EditAddressResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<EditAddressResponse>(exception: e);
    }
  }
}