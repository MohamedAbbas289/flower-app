import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/orders/domain/entities/order_entity.dart';
import 'package:flower_app/features/orders/domain/repository/orders_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrdersUseCase {
  final OrdersRepository _ordersRepository;

  GetOrdersUseCase(this._ordersRepository);

  Future<BaseResponse<List<OrderEntity>>> execute() {
    return _ordersRepository.getOrders();
  }
}
