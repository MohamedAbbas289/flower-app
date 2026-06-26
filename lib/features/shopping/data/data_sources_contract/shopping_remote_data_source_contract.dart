import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/shopping/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/shopping/data/models/cart_response_model.dart';
import 'package:flower_app/features/shopping/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/shopping/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/shopping/data/models/orders_response.dart';
import 'package:flower_app/features/shopping/data/models/product_details_response.dart';

abstract interface class ShoppingRemoteDataSourceContract {
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

  Future<BaseResponse<OrdersResponse>> getOrders();

  Future<BaseResponse<CashOrderResponseModel>> createCashOrder(
    PaymentRequestModel requestModel,
  );

  Future<BaseResponse<CheckoutSessionResponseModel>> createCheckoutSession(
    PaymentRequestModel requestModel,
  );

  Future<BaseResponse<ProductDetailsResponse>> getProductDetails({
    required String productId,
  });
}
