import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo_contract/cart_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateQuantityUseCase {
  final CartRepoContract _cartRepoContract;

  UpdateQuantityUseCase(this._cartRepoContract);

  Future<BaseResponse<CartEntity>> call(
    String productId,
    int quantity,
  ) async {
    return await _cartRepoContract.updateQuantity(productId, quantity);
  }
}