import 'package:flower_app/features/home/domain/entities/home_best_seller_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../repository_contract/home_repository_contract.dart';

@injectable
class GetBestSellerUseCase {
  final HomeRepositoryContract homeRepoContract;

  GetBestSellerUseCase(this.homeRepoContract);

  Future<BaseResponse<List<BestSellerEntity>>> call() async {
    return homeRepoContract.getAllBestSeller();
  }
}
