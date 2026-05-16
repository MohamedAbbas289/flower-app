import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/product_details/data/model/product_details_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'product_details_api_client.g.dart';

@lazySingleton
@RestApi()
abstract interface class ProductDetailsApiClient {
  @factoryMethod
  factory ProductDetailsApiClient(Dio dio) => _ProductDetailsApiClient(dio);

  @GET(Endpoints.getProducts)
  @Extra({ApiParam.requiresAuth: false})
  Future<ProductDetailsResponse> getProductDetails({
    @Query(ApiParam.id) required String productId,
  });
}
