import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/product_details/data/model/product_details_response.dart';

abstract interface class ProductDetailsRemoteDataSourceContract {
  Future<BaseResponse<ProductDetailsResponse>> getProductDetails(
    //   {
    //   required String productId,
    // }
  );
}
// TODO: Add productId when Feature/best-sellers is implemented