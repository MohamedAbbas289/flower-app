import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/data/data_sources/categories_remote_data_source.dart';
import 'package:flower_app/features/categories/data/models/category_model.dart';
import 'package:flower_app/features/categories/data/models/product_model.dart';
import 'package:flower_app/features/categories/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/categories/domain/repository/categories_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoriesRepository)
class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource _categoriesRemoteDataSource;

  CategoriesRepositoryImpl(this._categoriesRemoteDataSource);

  @override
  Future<BaseResponse<CategoriesResponseEntity>> getCategories({
    int? page,
    int? limit,
  }) async {
    try {
      final response = await _categoriesRemoteDataSource.getCategories(
        page: page,
        limit: limit,
      );
      final entities = response.categories?.map((e) => e.toEntity()).toList() ??
          [];
      final metadata = response.metadata?.toEntity();
      return SuccessBaseResponse(
        data: CategoriesResponseEntity(
          categories: entities,
          metadata: metadata,
        ),
      );
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<ProductsResponseEntity>> getProductsByCategory({
    String? categoryId,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await _categoriesRemoteDataSource.getProductsByCategory(
        categoryId: categoryId,
        page: page,
        limit: limit,
      );
      final entities = response.products?.map((e) => e.toEntity()).toList() ??
          [];
      final metadata = response.metadata?.toEntity();
      return SuccessBaseResponse(
        data: ProductsResponseEntity(
          products: entities,
          metadata: metadata,
        ),
      );
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }
}
