import 'package:flower_app/features/home_screen/domain/entities/best_seller_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../repositories/home_repo_contract.dart';

@injectable
class GetBestSellerUseCase {
  final HomeRepoContract homeRepoContract;

  GetBestSellerUseCase(this.homeRepoContract);

  Future<BaseResponse<List<BestSellerEntity>>> call() async {
    return homeRepoContract.getAllBestSeller();
  }
}
