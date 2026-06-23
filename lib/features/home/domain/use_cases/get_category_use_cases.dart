import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/category_entity.dart';
import '../repositories/home_repo_contract.dart';

@injectable
class GetCategoryUseCases {
  final HomeRepoContract homeRepoContract;

  GetCategoryUseCases(this.homeRepoContract);

  Future<BaseResponse<List<CategoryEntity>>> call() async {
    return homeRepoContract.getAllCategory();
  }
}
