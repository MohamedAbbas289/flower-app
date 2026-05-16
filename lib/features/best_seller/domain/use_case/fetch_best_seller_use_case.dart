import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/best_seller/domain/entity/best_seller_product_entity.dart';
import 'package:flower_app/features/best_seller/domain/repo/best_seller_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchBestSellerUseCase {
  final BestSellerRepoContract bestSellerRepo;

  FetchBestSellerUseCase(this.bestSellerRepo);
  Future<BaseResponse<List<BestSellerProductEntity>>> call() async {
    return await bestSellerRepo.fetchBestSellers();
  }
}
