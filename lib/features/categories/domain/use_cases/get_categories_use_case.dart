import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/domain/entities/category_entity.dart';
import 'package:flower_app/features/categories/domain/repository/categories_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesUseCase {
  final CategoriesRepository _categoriesRepository;

  GetCategoriesUseCase(this._categoriesRepository);

  Future<BaseResponse<List<CategoryEntity>>> execute() {
    return _categoriesRepository.getCategories();
  }
}
