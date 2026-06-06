import 'package:dio/dio.dart';
import 'package:flower_app/core/values/api_param.dart';
import 'package:flower_app/features/cart/data/models/cart_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../../../../core/values/endpoints.dart';

part 'cart_api_client.g.dart';

@lazySingleton
@RestApi()
abstract interface class CartApiClient {
  @factoryMethod
  factory CartApiClient(Dio dio) = _CartApiClient;
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


}
