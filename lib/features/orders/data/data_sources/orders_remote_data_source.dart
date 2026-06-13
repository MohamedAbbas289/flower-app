import 'package:flower_app/features/orders/api/responses/orders_response.dart';

abstract interface class OrdersRemoteDataSource {
  Future<OrdersResponse> getOrders();
}
