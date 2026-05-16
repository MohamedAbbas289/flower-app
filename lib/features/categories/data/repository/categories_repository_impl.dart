import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/categories/api/responses/categories_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:flower_app/features/categories/data/data_sources/categories_remote_data_source.dart';
import 'package:flower_app/features/categories/domain/entities/categories_response_entity.dart';
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
    const maxRetries = 3;
    for (var attempt = 0; attempt < maxRetries; attempt++) {
      final response = await _remoteDataSource.getCategories(
        page: page ?? 1,
        limit: limit ?? 50,
      );

      switch (response) {
        case SuccessBaseResponse<CategoriesResponse>():
          return SuccessBaseResponse(data: response.data.toEntity());
        case ErrorBaseResponse<CategoriesResponse>():
          if (attempt < maxRetries - 1) {
            await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
            continue;
          }
          return ErrorBaseResponse(exception: response.exception);
      }
    }
    // Should never reach here due to the return in the loop
    return ErrorBaseResponse(exception: Exception(AppStrings.retryFailed));
  }

  @override
  Future<BaseResponse<ProductsResponseEntity>> getProductsByCategory({
    String? categoryId,
    int? page,
    int? limit,
  }) async {
    final response = await _remoteDataSource.getProductsByCategory(
      categoryId: categoryId,
      page: page ?? 1,
      limit: limit ?? 10,
    );

    switch (response) {
      case SuccessBaseResponse<ProductsResponse>():
        return SuccessBaseResponse(data: response.data.toEntity());
      case ErrorBaseResponse<ProductsResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }
}
