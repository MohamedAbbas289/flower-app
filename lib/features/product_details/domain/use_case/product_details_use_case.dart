import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/product_details/domain/repo_contract/product_details_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsUseCase {
  ProductDetailsUseCase(this._productDetailsRepoContract);
  final ProductDetailsRepoContract _productDetailsRepoContract;
  Future<BaseResponse<ProductDetailsEntity>> getProductDetails(
    // {required String productId}
  ) async {
    return await _productDetailsRepoContract.getProductDetails(
      // productId : productId
    );
  }
}
// TODO: Add productId when Feature/best-sellers is implemented