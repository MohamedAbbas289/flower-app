import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:flower_app/features/search/api/search_api_client/search_api_client.dart';
import 'package:flower_app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRemoteDataSource)
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl(this._apiClient);

  final SearchApiClient _apiClient;

  @override
  Future<BaseResponse<ProductsResponse>> searchProducts({
    required String query,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _apiClient.searchProducts(
        query: query,
        page: page,
        limit: limit,
      );
      return SuccessBaseResponse<ProductsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<ProductsResponse>(exception: e);
    }
  }
}

