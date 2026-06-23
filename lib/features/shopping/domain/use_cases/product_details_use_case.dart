import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/shopping/domain/repository_contract/shopping_repository_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsUseCase {
  ProductDetailsUseCase(this._shoppingRepositoryContract);
  final ShoppingRepositoryContract _shoppingRepositoryContract;
  Future<BaseResponse<ProductDetailsEntity>> getProductDetails({
    required String productId,
  }) async {
    return await _shoppingRepositoryContract.getProductDetails(
      productId: productId,
    );
  }
}
