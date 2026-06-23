import 'dart:async';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home_screen/data/models/best_seller/best_seller.dart';
import 'package:flower_app/features/home_screen/data/models/category/category.dart';
import 'package:flower_app/features/home_screen/data/models/occasions/occasion.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources/home_remote_data_source_contract.dart';
import '../home_api_client/home_screen_api_client.dart';

@Injectable(as: HomeRemoteDataSourceContract)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSourceContract {
  final HomeScreenApiClient homeScreenApiClient;

  HomeRemoteDataSourceImpl(this.homeScreenApiClient);

  @override
  Future<BaseResponse<List<BestSellerDto>>> getAllBestSeller() async {
    try {
      final response = await homeScreenApiClient.getBestSellers();
      return SuccessBaseResponse<List<BestSellerDto>>(
        data: response.bestSeller ?? [],
      );
    } catch (e) {
      return ErrorBaseResponse<List<BestSellerDto>>(exception: e);
    }
  }

  @override
  Future<BaseResponse<List<CategoryDto>>> getAllCategory() async {
    try {
      final response = await homeScreenApiClient.getCategories();
      return SuccessBaseResponse<List<CategoryDto>>(
        data: response.categories ?? [],
      );
    } catch (e) {
      return ErrorBaseResponse<List<CategoryDto>>(exception: e);
    }
  }

  @override
  Future<BaseResponse<List<OccasionDto>>> getAllOccasion() async {
    try {
      final response = await homeScreenApiClient.getOccasions();
      return SuccessBaseResponse<List<OccasionDto>>(
        data: response.occasions ?? [],
      );
    } catch (e) {
      return ErrorBaseResponse<List<OccasionDto>>(exception: e);
    }
  }
}
