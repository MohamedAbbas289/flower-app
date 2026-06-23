import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/features/shopping/data/models/cart_response_model.dart';
import 'package:flower_app/features/shopping/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/shopping/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/shopping/data/models/orders_response.dart';
import 'package:flower_app/features/shopping/data/models/product_details_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/values/endpoints.dart';

part 'shopping_api_client.g.dart';

@lazySingleton
@RestApi()
abstract interface class ShoppingApiClient {
  @factoryMethod
  factory ShoppingApiClient(Dio dio) = _ShoppingApiClient;

  @GET(Endpoints.cart)
  Future<CartResponseModel> getCart();

  @POST(Endpoints.cart)
  Future<CartResponseModel> addToCart(
    @Field(ApiParam.product) String productId,
    @Field(ApiParam.quantity) int quantity,
  );

  @PUT(Endpoints.addOrEditOnCart)
  Future<CartResponseModel> updateQuantity(
    @Path(ApiParam.productId) String productId,
    @Field(ApiParam.quantity) int quantity,
  );

  @DELETE(Endpoints.addOrEditOnCart)
  Future<CartResponseModel> removeProductfromCart(
    @Path(ApiParam.productId) String productId,
  );

  @DELETE(Endpoints.cart)
  Future<CartResponseModel> clearCart();

  @GET(Endpoints.getOrders)
  Future<OrdersResponse> getOrders();

  @POST(Endpoints.createOrder)
  Future<CashOrderResponseModel> createCashOrder(
    @Body() Map<String, dynamic> body,
  );

  @POST(Endpoints.checkoutSession)
  Future<CheckoutSessionResponseModel> createCheckoutSession(
    @Body() Map<String, dynamic> body,
    @Query('url') String redirectUrl,
  );

  @GET(Endpoints.getProducts)
  @Extra({ApiParam.requiresAuth: false})
  Future<ProductDetailsResponse> getProductDetails({
    @Query(ApiParam.id) required String productId,
  });
}
