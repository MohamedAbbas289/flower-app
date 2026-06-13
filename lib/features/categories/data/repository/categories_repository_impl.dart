import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/responses/categories_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:flower_app/features/categories/data/data_sources/categories_remote_data_source.dart';
import 'package:flower_app/features/categories/data/models/category_model.dart';
import 'package:flower_app/features/categories/data/models/product_model.dart';
import 'package:flower_app/features/categories/domain/entities/categories_response_entity.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/categories/domain/repository/categories_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoriesRepository)
class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesRepositoryImpl(this._remoteDataSource);

  final CategoriesRemoteDataSource _remoteDataSource;

  @override
  Future<BaseResponse<CategoriesResponseEntity>> getCategories({
    int? page,
    int? limit,
  }) async {
    final response = await _remoteDataSource.getCategories(
      page: page ?? 1,
      limit: limit ?? 50,
    );

    switch (response) {
      case SuccessBaseResponse<CategoriesResponse>():
        final entities = response.data.categories
            ?.map((e) => e.toEntity())
            .toList()
            .cast<CategoryEntity>() ??
            <CategoryEntity>[];
        final metadata = response.data.metadata?.toEntity();
        return SuccessBaseResponse(
          data: CategoriesResponseEntity(
            categories: entities,
            metadata: metadata,
          ),
        );
      case ErrorBaseResponse<CategoriesResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }

  @override
  Future<BaseResponse<ProductsResponseEntity>> getProductsByCategory({
    String? categoryId,
    String? sort,
    int? page,
    int? limit,
  }) async {
    final response = await _remoteDataSource.getProductsByCategory(
      categoryId: categoryId,
      sort: sort,
      page: page ?? 1,
      limit: limit ?? 10,
    );

    switch (response) {
      case SuccessBaseResponse<ProductsResponse>():
        final entities = response.data.products
            ?.map((e) => e.toEntity())
            .toList()
            .cast<ProductEntity>() ??
            <ProductEntity>[];
        final metadata = response.data.metadata?.toEntity();
        return SuccessBaseResponse(
          data: ProductsResponseEntity(
            products: entities,
            metadata: metadata,
          ),
        );
      case ErrorBaseResponse<ProductsResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }
}
