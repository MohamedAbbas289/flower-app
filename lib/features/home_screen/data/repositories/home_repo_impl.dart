import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home_screen/domain/entities/best_seller_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/category_entity.dart';
import 'package:flower_app/features/home_screen/domain/entities/occasion_entity.dart';
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
  Future<BaseResponse<List<BestSellerEntity>>> getAllBestSeller() async {
    final response = await homeRemoteDataSourceContract.getAllBestSeller();
    switch (response) {
      case SuccessBaseResponse<List<BestSellerDto>>():
        return SuccessBaseResponse<List<BestSellerEntity>>(
          data: response.data.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<List<BestSellerDto>>():
        return ErrorBaseResponse<List<BestSellerEntity>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<List<CategoryEntity>>> getAllCategory() async {
    final response = await homeRemoteDataSourceContract.getAllCategory();
    switch (response) {
      case SuccessBaseResponse<List<CategoryDto>>():
        return SuccessBaseResponse<List<CategoryEntity>>(
          data: response.data.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<List<CategoryDto>>():
        return ErrorBaseResponse<List<CategoryEntity>>(
          exception: response.exception,
        );
    }
  }

  @override
  Future<BaseResponse<List<OccasionEntity>>> getAllOccasion() async {
    final response = await homeRemoteDataSourceContract.getAllOccasion();
    switch (response) {
      case SuccessBaseResponse<List<OccasionDto>>():
        return SuccessBaseResponse<List<OccasionEntity>>(
          data: response.data.map((e) => e.toDomain()).toList(),
        );
      case ErrorBaseResponse<List<OccasionDto>>():
        return ErrorBaseResponse<List<OccasionEntity>>(
          exception: response.exception,
        );
    }
  }
}
