import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/api/request_models/get_products_by_category_request_model.dart';
import 'package:flower_app/features/home/domain/entities/product_entity.dart';
import 'package:flower_app/features/home/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsByCategoryUseCase {
  GetProductsByCategoryUseCase(this._repository);

  final HomeRepositoryContract _repository;

  Future<BaseResponse<ProductsResponseEntity>> execute({
    required GetProductsByCategoryRequestModel requestModel,
    required int page,
    required int limit,
  }) async {
    final response = await _repository.getProductsByCategory(
      categoryId: requestModel.categoryId,
      sort: requestModel.sort,
      page: page,
      limit: limit,
    );

    if (!requestModel.reverseResults) return response;

    switch (response) {
      case SuccessBaseResponse<ProductsResponseEntity>():
        final reversed = response.data.products.reversed
            .cast<ProductEntity>()
            .toList();
        return SuccessBaseResponse(
          data: ProductsResponseEntity(
            products: reversed,
            metadata: response.data.metadata,
          ),
        );
      case ErrorBaseResponse<ProductsResponseEntity>():
        return response;
    }
  }
}
