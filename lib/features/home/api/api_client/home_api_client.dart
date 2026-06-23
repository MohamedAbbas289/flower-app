import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/home/data/models/best_seller_response.dart';
import 'package:flower_app/features/home/data/models/categories_response.dart';
import 'package:flower_app/features/home/data/models/category_products_response.dart';
import 'package:flower_app/features/home/data/models/home_best_seller_response.dart';
import 'package:flower_app/features/home/data/models/home_category_response.dart';
import 'package:flower_app/features/home/data/models/home_occasions_response.dart';
import 'package:flower_app/features/home/data/models/occasion_products_response.dart';
import 'package:flower_app/features/home/data/models/occasions_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'home_api_client.g.dart';

@lazySingleton
@RestApi()
abstract interface class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(Dio dio) = _HomeApiClient;

  @GET(Endpoints.getBestSeller)
  Future<BestSellerResponse> fetchBestSellers();

  @GET(Endpoints.getCategories)
  Future<CategoriesResponse> getCategories({
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @GET(Endpoints.getProducts)
  Future<ProductsResponse> getProductsByCategory({
    @Query('category') String? categoryId,
    @Query('sort') String? sort,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @GET(Endpoints.getCategories)
  Future<CategoryResponse> getHomeCategories();

  @GET(Endpoints.getOccasions)
  Future<HomeOccasionsResponse> getHomeOccasions();

  @GET(Endpoints.getBestSeller)
  Future<HomeBestSellerResponse> getBestSellers();

  @GET(Endpoints.getOccasions)
  @Extra({ApiParam.requiresAuth: false})
  Future<OccasionsResponse> getOccasions({
    @Query(ApiParam.page) required int page,
    @Query(ApiParam.limit) required int limit,
  });

  @GET(Endpoints.getProducts)
  @Extra({ApiParam.requiresAuth: false})
  Future<OccasionProductsResponse> getProductsByOccasion({
    @Query(ApiParam.occasions) required String occasionId,
    @Query(ApiParam.page) required int page,
    @Query(ApiParam.limit) required int limit,
  });

  @GET(Endpoints.searchProducts)
  Future<ProductsResponse> searchProducts({
    @Query('search') required String query,
  });
}
