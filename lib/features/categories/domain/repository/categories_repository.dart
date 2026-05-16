import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';

abstract interface class CategoriesRepository {
  Future<BaseResponse<CategoriesResponseEntity>> getCategories({
    int? page,
    int? limit,
  });

  Future<BaseResponse<ProductsResponseEntity>> getProductsByCategory({
    String? categoryId,
    int? page,
    int? limit,
  });
}
