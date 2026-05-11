import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';

abstract interface class ProductDetailsRepoContract {
  Future<BaseResponse<ProductDetailsEntity>> getProductDetails(
    // String productId,
  );
}
// TODO: Add productId when Feature/best-sellers is implemented