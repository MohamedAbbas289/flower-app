import 'package:dio/dio.dart';
import 'package:flower_app/features/product_details/data/model/product_details_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'product_details_api_client.g.dart';

// TODO: replace with dynamic id from navigation
const String tempProductId = "69d988764461df0f939b5820";

@lazySingleton
@RestApi()
abstract interface class ProductDetailsApiClient {
  @factoryMethod
  factory ProductDetailsApiClient(Dio dio) => _ProductDetailsApiClient(dio);

  @GET('/products/$tempProductId')
  Future<ProductDetailsResponse> getProductDetails();
}
