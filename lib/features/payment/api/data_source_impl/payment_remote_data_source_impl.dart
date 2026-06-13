import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/endpoints.dart';
import 'package:flower_app/features/payment/api/api_client/payment_api_client.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/data/data_source_contract/payment_remote_data_source_contract.dart';
import 'package:flower_app/features/payment/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/payment/data/models/checkout_session_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PaymentRemoteDataSourceContract)
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSourceContract {
  final PaymentApiClient _paymentApiClient;

  PaymentRemoteDataSourceImpl(this._paymentApiClient);

  @override
  Future<BaseResponse<CashOrderResponseModel>> createCashOrder(
    PaymentRequestModel requestModel,
  ) async {
    try {
      final response = await _paymentApiClient.createCashOrder(
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
      final response = await _paymentApiClient.createCheckoutSession(
        requestModel.toJson(),
        Endpoints.stripeRedirectUrl,
      );
      return SuccessBaseResponse(data: response);
    } catch (e) {
      return ErrorBaseResponse(exception: e);
    }
  }
}
