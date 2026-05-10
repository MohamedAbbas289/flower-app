

import 'dart:async';
import 'package:dio/dio.dart';
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
  Future<BaseResponse<List<BestSeller>>> getAllBestSeller() async{
      try{
    final response = await homeScreenApiClient.getBestSellers();
    return SuccessBaseResponse<List<BestSeller>>(data: response.bestSeller??[]);
  }catch (e){
    if (e is DioException) {
      return ErrorBaseResponse<List<BestSeller>>( exception: e );
    } else if (e is TimeoutException) {
      return ErrorBaseResponse<List<BestSeller>>(exception: e );
    }
      return ErrorBaseResponse<List<BestSeller>>(exception: e );
  }

  }

  @override
  Future<BaseResponse<List<Category>>> getAllCategory() async{
    try{
      final response = await homeScreenApiClient.getCategories();
      return SuccessBaseResponse<List<Category>>(data: response.categories??[]);
    }catch (e){
      if (e is DioException) {
        return ErrorBaseResponse<List<Category>>( exception: e );
      } else if (e is TimeoutException) {
        return ErrorBaseResponse<List<Category>>(exception: e );
      }
      return ErrorBaseResponse<List<Category>>(exception: e );
    }

  }

  @override
  Future<BaseResponse<List<Occasion>>> getAllOccasion() async{
    try{
      final response = await homeScreenApiClient.getOccasions();
      return SuccessBaseResponse<List<Occasion>>(data: response.occasions??[]);
    }catch (e){
      if (e is DioException) {
        return ErrorBaseResponse<List<Occasion>>( exception: e );
      } else if (e is TimeoutException) {
        return ErrorBaseResponse<List<Occasion>>(exception: e );
      }
      return ErrorBaseResponse<List<Occasion>>(exception: e );
    }
  }


}

