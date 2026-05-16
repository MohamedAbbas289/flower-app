import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/occasions/data/models/occasions_response.dart';
import 'package:flower_app/features/occasions/data/models/products_response.dart';

abstract interface class OccasionsRemoteDatasourceContract {
  Future<BaseResponse<OccasionsResponse>> getOccasions({
    required int page,
    required int limit,
  });

  Future<BaseResponse<ProductsResponse>> getProductsByOccasion({
    required String occasionId,
    required int page,
    required int limit,
  });
}
