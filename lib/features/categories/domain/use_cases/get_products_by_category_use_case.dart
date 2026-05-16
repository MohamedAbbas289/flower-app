import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/request_models/get_products_by_category_request_model.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/categories/domain/repository/categories_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsByCategoryUseCase {
  GetProductsByCategoryUseCase(this._repository);

  final CategoriesRepository _repository;

  Future<BaseResponse<ProductsResponseEntity>> execute({
    required GetProductsByCategoryRequestModel requestModel,
    required int page,
    required int limit,
  }) {
    return _repository.getProductsByCategory(
      categoryId: requestModel.categoryId,
      page: page,
      limit: limit,
    );
  }
}
