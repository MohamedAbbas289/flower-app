import 'package:flower_app/features/categories/api/categories_api_client/categories_api_client.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:flower_app/features/categories/data/data_sources/categories_remote_data_source.dart';
import 'package:injectable/injectable.dart';

import '../responses/categories_response.dart';

@Injectable(as: CategoriesRemoteDataSource)
class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final CategoriesApiClient _categoriesApiClient;

  CategoriesRemoteDataSourceImpl(this._categoriesApiClient);

  @override
  Future<CategoriesResponse> getCategories({int? page, int? limit}) {
    return _categoriesApiClient.getCategories(page: page, limit: limit);
  }

  @override
  Future<ProductsResponse> getProductsByCategory({
    String? categoryId,
    int? page,
    int? limit,
  }) {
    return _categoriesApiClient.getProductsByCategory(
      categoryId: categoryId,
      page: page,
      limit: limit,
    );
  }
}
