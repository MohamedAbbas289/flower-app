

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/home_repo_contract.dart';
import '../data_sources/home_remote_data_source_contract.dart';
import '../models/best_seller/best_seller.dart';
import '../models/category/category.dart';
import '../models/occasions/occasion.dart';

@Injectable(as: HomeRepoContract)
class HomeRepoImpl implements HomeRepoContract {
  final HomeRemoteDataSourceContract homeRemoteDataSourceContract;

  HomeRepoImpl(this.homeRemoteDataSourceContract);

  @override
  Future<BaseResponse<List<BestSellerModel>>> getAllBestSeller() async {
    final response = await homeRemoteDataSourceContract.getAllBestSeller();
    switch (response) {
      case SuccessBaseResponse<List<BestSellerDto>>():
        return SuccessBaseResponse<List<BestSellerModel>>(
          data: response.data.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<List<BestSellerDto>>():
        return ErrorBaseResponse<List<BestSellerModel>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<List<CategoryModel>>> getAllCategory() async {
    final response = await homeRemoteDataSourceContract.getAllCategory();
    switch (response) {
      case SuccessBaseResponse<List<CategoryDto>>():
        return SuccessBaseResponse<List<CategoryModel>>(
          data: response.data.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<List<CategoryDto>>():
        return ErrorBaseResponse<List<CategoryModel>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<List<OccasionModel>>> getAllOccasion() async {
    final response = await homeRemoteDataSourceContract.getAllOccasion();
    switch (response) {
      case SuccessBaseResponse<List<OccasionDto>>():
        return SuccessBaseResponse<List<OccasionModel>>(
          data: response.data.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<List<OccasionDto>>():
        return ErrorBaseResponse<List<OccasionModel>>(
          exception: response.exception,
        );
    }
  }
}
