import 'package:dio/dio.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'search_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class SearchApiClient {
  @factoryMethod
  factory SearchApiClient(Dio dio) = _SearchApiClient;

  @GET(Endpoints.searchProducts)
  Future<ProductsResponse> searchProducts({
    @Query('search') required String query,
  });
}
