import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/categories_api_client/categories_api_client.dart';
import 'package:flower_app/features/categories/api/responses/categories_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:flower_app/features/categories/data/data_sources/categories_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoriesRemoteDataSource)
class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  CategoriesRemoteDataSourceImpl(this._apiClient);

  final CategoriesApiClient _apiClient;

  @override
  Future<BaseResponse<CategoriesResponse>> getCategories({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _apiClient.getCategories(page: page, limit: limit);
      return SuccessBaseResponse<CategoriesResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<CategoriesResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<ProductsResponse>> getProductsByCategory({
    String? categoryId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _apiClient.getProductsByCategory(
        categoryId: categoryId,
        page: page,
        limit: limit,
      );
      return SuccessBaseResponse<ProductsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<ProductsResponse>(exception: e);
    }
  }
}
