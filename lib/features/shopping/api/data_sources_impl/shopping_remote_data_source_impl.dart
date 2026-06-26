import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/shopping/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/shopping/data/data_sources_contract/shopping_remote_data_source_contract.dart';
import 'package:flower_app/features/shopping/data/models/cart_response_model.dart';
import 'package:flower_app/features/shopping/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/shopping/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/shopping/data/models/orders_response.dart';
import 'package:flower_app/features/shopping/data/models/product_details_response.dart';
import 'package:injectable/injectable.dart';

import '../api_client/shopping_api_client.dart';

@Injectable(as: ShoppingRemoteDataSourceContract)
class ShoppingRemoteDataSourceImpl
    implements ShoppingRemoteDataSourceContract {
  final ShoppingApiClient _shoppingApiClient;

  ShoppingRemoteDataSourceImpl(this._shoppingApiClient);

  @override
  Future<BaseResponse<CartResponseModel>> getCart() async {
    try {
      final response = await _shoppingApiClient.getCart();
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<CartResponseModel>> addToCart(
    CartRequestModel requestModel,
  ) async {
    try {
      final response = await _shoppingApiClient.addToCart(
        requestModel.productId,
        requestModel.quantity,
      );
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<CartResponseModel>> updateQuantity(
    CartRequestModel requestModel,
  ) async {
    try {
      final response = await _shoppingApiClient.updateQuantity(
        requestModel.productId,
        requestModel.quantity,
      );
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<CartResponseModel>> removeProductfromCart(
    String productId,
  ) async {
    try {
      final response = await _shoppingApiClient.removeProductfromCart(
        productId,
      );
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<CartResponseModel>> clearCart() async {
    try {
      final response = await _shoppingApiClient.clearCart();
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<OrdersResponse>> getOrders() async {
    try {
      final response = await _shoppingApiClient.getOrders();
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<CashOrderResponseModel>> createCashOrder(
    PaymentRequestModel requestModel,
  ) async {
    try {
      final response = await _shoppingApiClient.createCashOrder(
        requestModel.toJson(),
      );
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<CheckoutSessionResponseModel>> createCheckoutSession(
    PaymentRequestModel requestModel,
  ) async {
    try {
      final response = await _shoppingApiClient.createCheckoutSession(
        requestModel.toJson(),
        Endpoints.stripeRedirectUrl,
      );
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }

  @override
  Future<BaseResponse<ProductDetailsResponse>> getProductDetails({
    required String productId,
  }) async {
    try {
      final response = await _shoppingApiClient.getProductDetails(
        productId: productId,
      );
      return SuccessBaseResponse<ProductDetailsResponse>(data: response);
    } catch (e) {
      return ErrorBaseResponse<ProductDetailsResponse>(exception: e);
    }
  }
}
