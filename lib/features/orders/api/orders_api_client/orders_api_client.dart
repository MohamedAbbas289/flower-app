import 'package:dio/dio.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/orders/api/responses/orders_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'orders_api_client.g.dart';

@lazySingleton
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @GET(Endpoints.getOrders)
  Future<OrdersResponse> getOrders();
}
