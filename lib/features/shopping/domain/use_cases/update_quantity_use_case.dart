import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo_contract/cart_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateQuantityUseCase {
  final CartRepoContract _cartRepoContract;

  UpdateQuantityUseCase(this._cartRepoContract);

  Future<BaseResponse<CartEntity>> call(CartRequestModel requestModel) async {
    return await _cartRepoContract.updateQuantity(requestModel);
  }
}
