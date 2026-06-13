import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/cart/data/models/cart_response_model.dart';

abstract interface class CartRemoteDataSourceContract {
  Future<BaseResponse<CartResponseModel>> getCart();
  Future<BaseResponse<CartResponseModel>> addToCart(
    CartRequestModel requestModel,
  );
  Future<BaseResponse<CartResponseModel>> updateQuantity(
    CartRequestModel requestModel,
  );
  Future<BaseResponse<CartResponseModel>> removeProductfromCart(
    String productId,
  );
  Future<BaseResponse<CartResponseModel>> clearCart();
}
