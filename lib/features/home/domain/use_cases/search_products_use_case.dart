import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchProductsUseCase {
  SearchProductsUseCase(this._repository);

  final HomeRepositoryContract _repository;

  Future<BaseResponse<ProductsResponseEntity>> execute({
    required String query,
  }) async {
    return await _repository.searchProducts(query: query);
  }
}
