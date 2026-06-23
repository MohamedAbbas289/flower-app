import 'dart:async';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/home/data/models/best_seller_response.dart';
import 'package:flower_app/features/home/data/models/categories_response.dart';
import 'package:flower_app/features/home/data/models/category_products_response.dart';
import 'package:flower_app/features/home/data/models/home_best_seller_dto.dart';
import 'package:flower_app/features/home/data/models/home_category_dto.dart';
import 'package:flower_app/features/home/data/models/home_occasion_dto.dart';
import 'package:flower_app/features/home/data/models/occasion_products_response.dart';
import 'package:flower_app/features/home/data/models/occasions_response.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_sources_contract/home_remote_data_source_contract.dart';
import '../api_client/home_api_client.dart';

@Injectable(as: HomeRemoteDataSourceContract)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSourceContract {
  final HomeApiClient homeApiClient;

  HomeRemoteDataSourceImpl(this.homeApiClient);

  @override
  Future<BaseResponse<BestSellerResponse>> fetchBestSellers() async {
    try {
      final response = await homeApiClient.fetchBestSellers();
      return SuccessBaseResponse<BestSellerResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<BestSellerResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<CategoriesResponse>> getCategories({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await homeApiClient.getCategories(
        page: page,
        limit: limit,
      );
      return SuccessBaseResponse<CategoriesResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<CategoriesResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<ProductsResponse>> getProductsByCategory({
    String? categoryId,
    String? sort,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await homeApiClient.getProductsByCategory(
        categoryId: categoryId,
        sort: sort,
        page: page,
        limit: limit,
      );
      return SuccessBaseResponse<ProductsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<ProductsResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<List<BestSellerDto>>> getAllBestSeller() async {
    try {
      final response = await homeApiClient.getBestSellers();
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
      final response = await homeApiClient.getHomeCategories();
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
      final response = await homeApiClient.getHomeOccasions();
      return SuccessBaseResponse<List<OccasionDto>>(
        data: response.occasions ?? [],
      );
    } catch (e) {
      return ErrorBaseResponse<List<OccasionDto>>(exception: e);
    }
  }

  @override
  Future<BaseResponse<OccasionsResponse>> getOccasions({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await homeApiClient.getOccasions(
        page: page,
        limit: limit,
      );
      return SuccessBaseResponse<OccasionsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<OccasionsResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<OccasionProductsResponse>> getProductsByOccasion({
    required String occasionId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await homeApiClient.getProductsByOccasion(
        occasionId: occasionId,
        page: page,
        limit: limit,
      );
      return SuccessBaseResponse<OccasionProductsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<OccasionProductsResponse>(exception: e);
    }
  }

  @override
  Future<BaseResponse<ProductsResponse>> searchProducts({
    required String query,
  }) async {
    try {
      final response = await homeApiClient.searchProducts(query: query);
      return SuccessBaseResponse<ProductsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<ProductsResponse>(exception: e);
    }
  }
}
