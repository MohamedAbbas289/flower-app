import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/cart/data/data_source_contract/cart_remote_data_source_contract.dart';
import 'package:flower_app/features/cart/data/models/cart_model.dart';
import 'package:flower_app/features/cart/data/models/cart_response_model.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flower_app/features/cart/domain/repo_contract/cart_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRepoContract)
class CartRepoImpl implements CartRepoContract {
  final CartRemoteDataSourceContract _dataSource;

  CartRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<CartEntity>> getCart() async {
    final response = await _dataSource.getCart();
    return _mapResponse(response);
  }

  @override
  Future<BaseResponse<CartEntity>> addToCart(
    CartRequestModel requestModel,
  ) async {
    final response = await _dataSource.addToCart(requestModel);
    return _mapResponse(response);
  }

  @override
  Future<BaseResponse<CartEntity>> updateQuantity(
    CartRequestModel requestModel,
  ) async {
    final response = await _dataSource.updateQuantity(requestModel);
    return _mapResponse(response);
  }

  @override
  Future<BaseResponse<CartEntity>> removeProductfromCart(
    String productId,
  ) async {
    final response = await _dataSource.removeProductfromCart(productId);
    return _mapResponse(response);
  }

  @override
  Future<BaseResponse<CartEntity>> clearCart() async {
    final response = await _dataSource.clearCart();
    return _mapResponse(response);
  }

  BaseResponse<CartEntity> _mapResponse(
    BaseResponse<CartResponseModel> response,
  ) {
    switch (response) {
      case SuccessBaseResponse<CartResponseModel>():
        return SuccessBaseResponse(
          data:
              response.data.cart?.toEntity() ??
              const CartEntity(
                id: '',
                cartItems: [],
                totalPrice: 0,
                totalPriceAfterDiscount: 0,
                discount: 0,
                numOfCartItems: 0,
              ),
        );
      case ErrorBaseResponse<CartResponseModel>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }
}
