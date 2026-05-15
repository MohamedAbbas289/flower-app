import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/occasions/api/api_client/occasions_api_client.dart';
import 'package:flower_app/features/occasions/data/datasources_contract/occasions_remote_datasource_contract.dart';
import 'package:flower_app/features/occasions/data/models/occasions_response.dart';
import 'package:flower_app/features/occasions/data/models/products_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OccasionsRemoteDatasourceContract)
class OccasionsDatasourceImpl implements OccasionsRemoteDatasourceContract {
  OccasionsDatasourceImpl(this._apiClient);
  final OccasionsApiClient _apiClient;

  @override
  Future<BaseResponse<OccasionsResponse>> getOccasions({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _apiClient.getOccasions(page: page, limit: limit);
      return SuccessBaseResponse<OccasionsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<OccasionsResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<ProductsResponse>> getProductsByOccasion({
    required String occasionId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _apiClient.getProductsByOccasion(
        occasionId: occasionId,
        page: page,
        limit: limit,
      );
      return SuccessBaseResponse<ProductsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<ProductsResponse>(exception: e);
    }
  }
}
