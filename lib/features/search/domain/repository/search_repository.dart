import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/categories/domain/entities/products_response_entity.dart';

abstract interface class SearchRepository {
  Future<BaseResponse<ProductsResponseEntity>> searchProducts({
    required String query,
  });
}
