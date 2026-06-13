import 'package:dio/dio.dart';
import 'package:flower_app/features/payment/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/payment/data/models/checkout_session_response_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/values/endpoints.dart';

part 'payment_api_client.g.dart';

@lazySingleton
@RestApi()
abstract interface class PaymentApiClient {
  @factoryMethod
  factory PaymentApiClient(Dio dio) = _PaymentApiClient;

  @POST(Endpoints.createOrder)
  Future<CashOrderResponseModel> createCashOrder(
    @Body() Map<String, dynamic> body,
  );

  @POST(Endpoints.checkoutSession)
  Future<CheckoutSessionResponseModel> createCheckoutSession(
    @Body() Map<String, dynamic> body,
    @Query('url') String redirectUrl,
  );
}
