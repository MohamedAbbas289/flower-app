import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo_contract/cart_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearCartUseCase {
  final CartRepoContract _cartRepoContract;

  ClearCartUseCase(this._cartRepoContract);

  Future<BaseResponse<CartEntity>> call() async {
    return await _cartRepoContract.clearCart();
  }
}
