import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/occasions/domain/entities/occasion_entity.dart';import 'package:flower_app/features/occasions/domain/entities/products_entity.dart';

abstract interface class OccasionsRepositoryContract {
  Future<BaseResponse<OccasionsEntity>> getOccasions({
    required int page,
    required int limit,
  });

Future<BaseResponse<ProductsEntity>> getProductsByOccasion({
  required String occasionId,
  required int page,
  required int limit,
});
}