import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/responses/categories_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';

abstract interface class CategoriesRemoteDataSource {
  Future<BaseResponse<CategoriesResponse>> getCategories({
    required int page,
    required int limit,
  });

  Future<BaseResponse<ProductsResponse>> getProductsByCategory({
    String? categoryId,
    String? sort,
    required int page,
    required int limit,
  });
}
