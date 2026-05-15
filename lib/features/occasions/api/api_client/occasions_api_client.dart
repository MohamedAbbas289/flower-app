import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/occasions/data/models/occasions_response.dart';
import 'package:flower_app/features/occasions/data/models/products_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'occasions_api_client.g.dart';

@lazySingleton
@RestApi()
abstract interface class OccasionsApiClient {
  @factoryMethod
  factory OccasionsApiClient(Dio dio) = _OccasionsApiClient;

  @GET(Endpoints.getOccasions)
  @Extra({ApiParam.requiresAuth: false})
  Future<OccasionsResponse> getOccasions({
    @Query(ApiParam.page) required int page,
    @Query(ApiParam.limit) required int limit,
  });

  @GET(Endpoints.getProducts)
  @Extra({ApiParam.requiresAuth: false})
  Future<ProductsResponse> getProductsByOccasion({
    @Query(ApiParam.occasions) required String occasionId,
    @Query(ApiParam.page) required int page,
    @Query(ApiParam.limit) required int limit,
  });
}
