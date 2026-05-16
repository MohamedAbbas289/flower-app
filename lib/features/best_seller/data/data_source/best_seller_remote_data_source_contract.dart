import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/best_seller/data/model/best_seller_response.dart';

abstract class BestSellerRemoteDataSourceContract {
  Future<BaseResponse<BestSellerResponse>> fetchBestSellers();
}