import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/payment/data/models/checkout_session_response_model.dart';

abstract interface class PaymentRemoteDataSourceContract {
  Future<BaseResponse<CashOrderResponseModel>> createCashOrder({
    required PaymentRequestModel requestModel,
  });

  Future<BaseResponse<CheckoutSessionResponseModel>> createCheckoutSession({
    required PaymentRequestModel requestModel,
  });
}
