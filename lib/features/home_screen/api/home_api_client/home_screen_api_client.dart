
import 'package:dio/dio.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/home_screen/data/models/category/category_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../data/models/best_seller/best_seller_response.dart';
import '../../data/models/occasions/occasions_response.dart';
part 'home_screen_api_client.g.dart';

@injectable
@RestApi()
abstract class HomeScreenApiClient {
@factoryMethod
factory HomeScreenApiClient(Dio dio) = _HomeScreenApiClient;

@GET(Endpoints.getCategories)
  Future<CategoryResponse> getCategories();
@GET(Endpoints.getOccasions)
  Future<OccasionsResponse> getOccasions();
@GET(Endpoints.getBestSeller)
  Future<BestSellerResponse> getBestSellers();






}