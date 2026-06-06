import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/data/models/cart_response_model.dart';

abstract interface class CartRemoteDataSourceContract {
  Future<BaseResponse<CartResponseModel>> getCart();
  Future<BaseResponse<CartResponseModel>> addToCart(
    String productId,
    int quantity,
  );
  Future<BaseResponse<CartResponseModel>> updateQuantity(
    String productId,
    int quantity,
  );
  Future<BaseResponse<CartResponseModel>> removeProductfromCart(String productId);
}
