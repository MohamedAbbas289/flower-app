import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/orders/data/data_sources/orders_remote_data_source.dart';
import 'package:flower_app/features/orders/data/models/order_model.dart';
import 'package:flower_app/features/orders/domain/entities/order_entity.dart';
import 'package:flower_app/features/orders/domain/repository/orders_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepositoryImpl(this._remoteDataSource);

  @override
  Future<BaseResponse<List<OrderEntity>>> getOrders() async {
    try {
      final response = await _remoteDataSource.getOrders();
      final entities =
          response.orders
              ?.map((e) => e.toEntity())
              .toList()
              .cast<OrderEntity>() ??
          <OrderEntity>[];
      return SuccessBaseResponse(data: entities);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }
}
