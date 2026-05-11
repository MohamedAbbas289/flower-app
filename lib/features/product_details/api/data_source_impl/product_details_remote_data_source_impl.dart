import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/product_details/api/api_client/product_details_api_client.dart';
import 'package:flower_app/features/product_details/data/data_source_contract/product_details_remote_data_source_contract.dart';
import 'package:flower_app/features/product_details/data/model/product_details_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductDetailsRemoteDataSourceContract)
class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSourceContract {
  ProductDetailsRemoteDataSourceImpl(this._productDetailsApiClient);
  final ProductDetailsApiClient _productDetailsApiClient;
  @override
  Future<BaseResponse<ProductDetailsResponse>> getProductDetails(
    //   {
    //    required String productId,
    // }
  ) async {
    try {
      final response = await _productDetailsApiClient.getProductDetails(
        // productId: productId,
      );
      return SuccessBaseResponse<ProductDetailsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<ProductDetailsResponse>(exception: e);
    }
  }
}
// TODO: Add productId when Feature/best-sellers is implemented