import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';

abstract interface class PaymentRepoContract {
  Future<BaseResponse<CashOrderEntity>> createCashOrder({
    required PaymentRequestModel requestModel,
  });

  Future<BaseResponse<CheckoutSessionEntity>> createCheckoutSession({
    required PaymentRequestModel requestModel,
  });
}
