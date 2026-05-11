import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/request_models/get_products_by_category_request_model.dart';
import 'package:flower_app/features/categories/domain/entities/product_entity.dart';
import 'package:flower_app/features/categories/domain/repository/categories_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProductsByCategoryUseCase {
  final CategoriesRepository _categoriesRepository;

  GetProductsByCategoryUseCase(this._categoriesRepository);

  Future<BaseResponse<List<ProductEntity>>> execute({
    required GetProductsByCategoryRequestModel requestModel,
  }) {
    return _categoriesRepository.getProductsByCategory(
      categoryId: requestModel.categoryId,
    );
  }
}
