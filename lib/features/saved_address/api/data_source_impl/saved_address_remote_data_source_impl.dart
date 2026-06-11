import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/saved_address/api/saved_address_api_client/saved_address_api_client.dart';
import 'package:flower_app/features/saved_address/data/data_sources_contract/saved_address_remote_data_source_contract.dart';
import 'package:flower_app/features/saved_address/data/models/get_addresses_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SavedAddressDataSourceContract)
class SavedAddressDataSourceImpl implements SavedAddressDataSourceContract {
  final SavedAddressApiClient _apiClient;

  SavedAddressDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<GetAddressesResponse>> getAddresses() async {
    try {
      final response = await _apiClient.getAddresses();
      return SuccessBaseResponse<GetAddressesResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<GetAddressesResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<bool>> deleteAddress(String id) async {
    try {
      await _apiClient.deleteAddress(id);
      return SuccessBaseResponse<bool>(data: true);
    } catch (e) {
      return ErrorBaseResponse<bool>(exception: e);
    }
  }
}