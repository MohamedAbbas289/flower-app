import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/orders/domain/entities/order_entity.dart';

abstract interface class OrdersRepository {
  Future<BaseResponse<List<OrderEntity>>> getOrders();
}
