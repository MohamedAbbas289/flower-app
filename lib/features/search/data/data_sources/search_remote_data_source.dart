import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/api/responses/products_response.dart';

abstract interface class SearchRemoteDataSource {
  Future<BaseResponse<ProductsResponse>> searchProducts({
    required String query,
  });
}
