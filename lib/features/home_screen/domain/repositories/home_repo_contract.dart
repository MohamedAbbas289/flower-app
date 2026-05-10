
import 'package:flower_app/features/home_screen/domain/entities/best_seller_model.dart';
import 'package:flower_app/features/home_screen/domain/entities/category_model.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_model.dart';

import '../../../../config/base_response/base_response.dart';

abstract class HomeRepoContract {

  Future<BaseResponse<List<CategoryModel>>> getAllCategory();
  Future<BaseResponse<List<OccasionModel>>> getAllOccasion();
  Future<BaseResponse<List<BestSellerModel>>> getAllBestSeller();


}
