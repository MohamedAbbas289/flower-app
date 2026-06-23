import '../../../../config/base_response/base_response.dart';
import '../models/best_seller/best_seller.dart';
import '../models/category/category.dart';
import '../models/occasions/occasion.dart';

abstract interface class HomeRemoteDataSourceContract {

  Future<BaseResponse<List<CategoryDto>>> getAllCategory();
  Future<BaseResponse<List<BestSellerDto>>> getAllBestSeller();
  Future<BaseResponse<List<OccasionDto>>> getAllOccasion();

}