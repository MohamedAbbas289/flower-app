




import '../../../../config/base_response/base_response.dart';
import '../models/best_seller/best_seller.dart';
import '../models/category/category.dart';
import '../models/occasions/occasion.dart';

abstract class HomeRemoteDataSourceContract {

  Future<BaseResponse<List<Category>>> getAllCategory();
  Future<BaseResponse<List<BestSeller>>> getAllBestSeller();
  Future<BaseResponse<List<Occasion>>> getAllOccasion();

}