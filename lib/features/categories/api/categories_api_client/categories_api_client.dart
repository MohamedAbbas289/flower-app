import 'package:dio/dio.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../responses/categories_response.dart';

part 'categories_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class CategoriesApiClient {
  @factoryMethod
  factory CategoriesApiClient(Dio dio) = _CategoriesApiClient;

  @GET(Endpoints.getCategories)
  Future<CategoriesResponse> getCategories();

  @GET(Endpoints.getProducts)
  Future<ProductsResponse> getProductsByCategory({
    @Query('category') String? categoryId,
  });
}
