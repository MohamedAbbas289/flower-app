import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/search/domain/repository/search_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchProductsUseCase {
  SearchProductsUseCase(this._repository);

  final SearchRepository _repository;

  Future<BaseResponse<ProductsResponseEntity>> execute({
    required String query,
  }) async {
    return await _repository.searchProducts(query: query);
  }
}
