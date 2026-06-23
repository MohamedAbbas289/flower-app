import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/domain/entities/best_seller_product_entity.dart';
import 'package:flower_app/features/home/domain/repository_contract/home_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchBestSellerUseCase {
  final HomeRepositoryContract homeRepositoryContract;

  FetchBestSellerUseCase(this.homeRepositoryContract);
  Future<BaseResponse<List<BestSellerProductEntity>>> call() async {
    return await homeRepositoryContract.fetchBestSellers();
  }
}
