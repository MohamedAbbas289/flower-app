import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:flower_app/features/categories/data/models/product_model.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:flower_app/features/search/domain/repository/search_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._remoteDataSource);

  final SearchRemoteDataSource _remoteDataSource;

  @override
  Future<BaseResponse<ProductsResponseEntity>> searchProducts({
    required String query,
  }) async {
    final response = await _remoteDataSource.searchProducts(query: query);

    switch (response) {
      case SuccessBaseResponse<ProductsResponse>():
        final entities =
            response.data.products
                ?.map((e) => e.toEntity())
                .toList()
                .cast<ProductEntity>() ??
            <ProductEntity>[];
        final metadata = response.data.metadata?.toEntity();
        return SuccessBaseResponse(
          data: ProductsResponseEntity(products: entities, metadata: metadata),
        );
      case ErrorBaseResponse<ProductsResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }
}
