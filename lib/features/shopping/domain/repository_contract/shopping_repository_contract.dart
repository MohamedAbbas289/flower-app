import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/shopping/api/request_models/cart_request_model.dart';
import 'package:flower_app/features/shopping/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/shopping/domain/entities/cart_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/order_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/product_details_entity.dart';

abstract interface class ShoppingRepositoryContract {
  Future<BaseResponse<CartEntity>> getCart();

  Future<BaseResponse<CartEntity>> addToCart(CartRequestModel requestModel);

  Future<BaseResponse<CartEntity>> updateQuantity(
    CartRequestModel requestModel,
  );

  Future<BaseResponse<CartEntity>> removeProductfromCart(String productId);

  Future<BaseResponse<CartEntity>> clearCart();

  Future<BaseResponse<List<OrderEntity>>> getOrders();

  Future<BaseResponse<CashOrderEntity>> createCashOrder(
    PaymentRequestModel requestModel,
  );

  Future<BaseResponse<CheckoutSessionEntity>> createCheckoutSession(
    PaymentRequestModel requestModel,
  );

  Future<BaseResponse<ProductDetailsEntity>> getProductDetails({
    required String productId,
  });

}
