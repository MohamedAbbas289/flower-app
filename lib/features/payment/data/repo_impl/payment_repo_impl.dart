import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/data/data_source_contract/payment_remote_data_source_contract.dart';
import 'package:flower_app/features/payment/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/payment/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/payment/domain/repo_contract/payment_repo_contract.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PaymentRepoContract)
class PaymentRepoImpl implements PaymentRepoContract {
  final PaymentRemoteDataSourceContract _paymentRemoteDataSourceContract;

  PaymentRepoImpl(this._paymentRemoteDataSourceContract);

  @override
  Future<BaseResponse<CashOrderEntity>> createCashOrder({
    required PaymentRequestModel requestModel,
  }) async {
    final response = await _paymentRemoteDataSourceContract.createCashOrder(
      requestModel: requestModel,
    );
    switch (response) {
      case SuccessBaseResponse<CashOrderResponseModel>():
        return SuccessBaseResponse(data: response.data.toEntity());
      case ErrorBaseResponse<CashOrderResponseModel>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }

  @override
  Future<BaseResponse<CheckoutSessionEntity>> createCheckoutSession({
    required PaymentRequestModel requestModel,
  }) async {
    final response = await _paymentRemoteDataSourceContract
        .createCheckoutSession(requestModel: requestModel);
    switch (response) {
      case SuccessBaseResponse<CheckoutSessionResponseModel>():
        return SuccessBaseResponse(data: response.data.toEntity());
      case ErrorBaseResponse<CheckoutSessionResponseModel>():
        return ErrorBaseResponse(exception: response.exception);
    }
  }
}
