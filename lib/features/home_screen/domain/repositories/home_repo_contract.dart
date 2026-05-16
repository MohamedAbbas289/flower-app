import 'package:flower_app/features/home_screen/domain/entities/best_seller_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/category_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_entity.dart';

import '../../../../config/base_response/base_response.dart';

abstract interface class HomeRepoContract {
  Future<BaseResponse<List<CategoryEntity>>> getAllCategory();
  Future<BaseResponse<List<OccasionEntity>>> getAllOccasion();
  Future<BaseResponse<List<BestSellerEntity>>> getAllBestSeller();
}
