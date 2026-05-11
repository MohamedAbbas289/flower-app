import 'package:flower_app/features/categories/api/responses/products_response.dart';

import '../../api/responses/categories_response.dart';

abstract interface class CategoriesRemoteDataSource {
  Future<CategoriesResponse> getCategories();

  Future<ProductsResponse> getProductsByCategory({String? categoryId});
}
