import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/request_models/get_products_by_category_request_model.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';
import 'package:flower_app/features/categories/domain/repository/categories_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsByCategoryUseCase {
  final CategoriesRepository _categoriesRepository;

  GetProductsByCategoryUseCase(this._categoriesRepository);

  Future<BaseResponse<ProductsResponseEntity>> execute({
    required GetProductsByCategoryRequestModel requestModel,
    int? page,
    int? limit,
  }) {
    return _categoriesRepository.getProductsByCategory(
      categoryId: requestModel.categoryId,
      page: page,
      limit: limit,
    );
  }
}
