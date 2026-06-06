import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/domain/entities/cart_entity.dart';

abstract interface class CartRepoContract {
  Future<BaseResponse<CartEntity>> getCart();
  Future<BaseResponse<CartEntity>> addToCart(String productId, int quantity);
  Future<BaseResponse<CartEntity>> updateQuantity(String productId, int quantity);
  Future<BaseResponse<CartEntity>> removeProductfromCart(String productId);
}