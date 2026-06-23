import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../entities/home_category_entity.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetCategoryUseCases {
  final HomeRepositoryContract homeRepoContract;

  GetCategoryUseCases(this.homeRepoContract);

  Future<BaseResponse<List<HomeCategoryEntity>>> call() async {
    return homeRepoContract.getAllCategory();
  }
}
