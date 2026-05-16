import 'package:dio/dio.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/best_seller/data/model/best_seller_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'best_seller_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class BestSellerApiClient {
  @factoryMethod
  factory BestSellerApiClient(Dio dio) = _BestSellerApiClient;
  @GET(Endpoints.getBestSeller)
  Future<BestSellerResponse> fetchBestSellers();
}
