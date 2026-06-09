import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

abstract interface class CartRepoContract {
  Future<BaseResponse<CartEntity>> getCart();
  Future<BaseResponse<CartEntity>> addToCart(CartRequestModel requestModel);
  Future<BaseResponse<CartEntity>> updateQuantity(
    CartRequestModel requestModel,
  );
  Future<BaseResponse<CartEntity>> removeProductfromCart(String productId);
}
