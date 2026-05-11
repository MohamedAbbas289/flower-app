import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';

abstract interface class CategoriesRepository {
  Future<BaseResponse<List<CategoryEntity>>> getCategories();

  Future<BaseResponse<List<ProductEntity>>> getProductsByCategory({
    String? categoryId,
  });
}
