import 'package:flower_app/features/orders/api/orders_api_client/orders_api_client.dart';
import 'package:flower_app/features/orders/api/responses/orders_response.dart';
import 'package:flower_app/features/orders/data/data_sources/orders_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final OrdersApiClient _ordersApiClient;

  OrdersRemoteDataSourceImpl(this._ordersApiClient);

  @override
  Future<OrdersResponse> getOrders() {
    return _ordersApiClient.getOrders();
  }
}
