import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/product_details/data/data_source_contract/product_details_remote_data_source_contract.dart';
import 'package:flower_app/features/product_details/data/model/product_details_mapper.dart';
import 'package:flower_app/features/product_details/data/model/product_details_response.dart';
import 'package:flower_app/features/product_details/domain/entities/product_details_entity.dart';
import 'package:flower_app/features/product_details/domain/repo_contract/product_details_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductDetailsRepoContract)
class ProductDetailsRepoImpl implements ProductDetailsRepoContract {
  final ProductDetailsRemoteDataSourceContract
  _productDetailsRemoteDataSourceContract;

  ProductDetailsRepoImpl(this._productDetailsRemoteDataSourceContract);

  @override
  Future<BaseResponse<ProductDetailsEntity>> getProductDetails({
    required String productId,
  }) async {
    final response = await _productDetailsRemoteDataSourceContract
        .getProductDetails(productId: productId);

    switch (response) {
      case SuccessBaseResponse<ProductDetailsResponse>():
        final data = response.data.toEntity();
        return SuccessBaseResponse(data: data);
      case ErrorBaseResponse<ProductDetailsResponse>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }
}
