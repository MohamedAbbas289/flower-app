import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/cart/api/api_client/cart_api_client.dart';
import 'package:flower_app/features/cart/data/data_source_contract/cart_remote_data_source_contract.dart';
import 'package:flower_app/features/cart/data/models/cart_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRemoteDataSourceContract)
class CartRemoteDataSourceImpl implements CartRemoteDataSourceContract {
  final CartApiClient _cartApiClient;

  CartRemoteDataSourceImpl(this._cartApiClient);

  @override
  Future<BaseResponse<CartResponseModel>> getCart() async {
    try {
      final response = await _cartApiClient.getCart();
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<CartResponseModel>> addToCart(
    String productId,
    int quantity,
  ) async {
    try {
      final response = await _cartApiClient.addToCart(productId, quantity);
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<CartResponseModel>> updateQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      final response = await _cartApiClient.updateQuantity(productId, quantity);
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<CartResponseModel>> removeCartItem(String itemId) async {
    try {
      final response = await _cartApiClient.removeCartItem(itemId);
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<void>> clearCart() async {
    try {
      await _cartApiClient.clearCart();
      return SuccessBaseResponse(data: null);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }
}