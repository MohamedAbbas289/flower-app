import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/occasions/domain/entities/products_entity.dart';
import 'package:flower_app/features/occasions/domain/repositories_contract/occasions_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsByOccasionUseCase {
  GetProductsByOccasionUseCase(this._repository);
  final OccasionsRepositoryContract _repository;

  Future<BaseResponse<ProductsEntity>> execute({
    required String occasionId,
    required int page,
    required int limit,
  }) async {
    return await _repository.getProductsByOccasion(
      occasionId: occasionId,
      page: page,
      limit: limit,
    );
  }
}
