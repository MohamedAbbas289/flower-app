import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/data/data_sources/categories_remote_data_source.dart';
import 'package:flower_app/features/categories/data/models/category_model.dart';
import 'package:flower_app/features/categories/data/models/product_model.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:flower_app/features/categories/domain/repository/categories_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoriesRepository)
class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource _remoteDataSource;

  CategoriesRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<CategoryEntity>>> getCategories() async {
    try {
      final response = await _remoteDataSource.getCategories();
      final entities = (response.categories ?? [])
          .map((CategoryModel model) => model.toEntity())
          .toList();
      return SuccessBaseResponse(data: entities);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<List<ProductEntity>>> getProductsByCategory({
    String? categoryId,
  }) async {
    try {
      final response = await _remoteDataSource.getProductsByCategory(
        categoryId: categoryId,
      );
      final entities = (response.products ?? [])
          .map((ProductModel model) => model.toEntity())
          .toList();
      return SuccessBaseResponse(data: entities);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }
}
