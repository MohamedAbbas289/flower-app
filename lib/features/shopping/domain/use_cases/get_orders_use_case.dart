import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/domain/entities/order_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrdersUseCase {
  final ShoppingRepositoryContract _shoppingRepositoryContract;

  GetOrdersUseCase(this._shoppingRepositoryContract);

  Future<BaseResponse<List<OrderEntity>>> execute() {
    return _shoppingRepositoryContract.getOrders();
  }
}
