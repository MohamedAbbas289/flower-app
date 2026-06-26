import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/domain/entities/cart_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCartUseCase {
  final ShoppingRepositoryContract _shoppingRepositoryContract;

  GetCartUseCase(this._shoppingRepositoryContract);

  Future<BaseResponse<CartEntity>> execute() async {
    return await _shoppingRepositoryContract.getCart();
  }
}