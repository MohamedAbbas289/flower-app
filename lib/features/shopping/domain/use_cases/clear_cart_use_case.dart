import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/domain/entities/cart_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearCartUseCase {
  final ShoppingRepositoryContract _shoppingRepositoryContract;

  ClearCartUseCase(this._shoppingRepositoryContract);

  Future<BaseResponse<CartEntity>> call() async {
    return await _shoppingRepositoryContract.clearCart();
  }
}
