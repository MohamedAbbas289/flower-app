import 'package:flower_app/features/categories/api/responses/products_response.dart';

import '../../api/responses/categories_response.dart';

abstract interface class CategoriesRemoteDataSource {
  Future<CategoriesResponse> getCategories({int? page, int? limit});

  Future<ProductsResponse> getProductsByCategory({
    String? categoryId,
    int? page,
    int? limit,
  });
}
