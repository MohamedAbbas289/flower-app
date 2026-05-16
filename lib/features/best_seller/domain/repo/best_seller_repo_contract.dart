import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/best_seller/domain/entity/best_seller_product_entity.dart';

abstract class BestSellerRepoContract {
  Future<BaseResponse<List<BestSellerProductEntity>>> fetchBestSellers();
}
