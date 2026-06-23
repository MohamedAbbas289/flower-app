import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/domain/entities/products_entity.dart';
import 'package:flower_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsByOccasionUseCase {
  GetProductsByOccasionUseCase(this._repository);
  final HomeRepositoryContract _repository;

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
