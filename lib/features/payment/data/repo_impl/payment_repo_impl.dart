import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/data/data_source_contract/payment_remote_data_source_contract.dart';
import 'package:flower_app/features/payment/data/models/cash_order_response_model.dart';
import 'package:flower_app/features/payment/data/models/checkout_session_response_model.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/payment/domain/repo_contract/payment_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PaymentRepoContract)
class PaymentRepoImpl implements PaymentRepoContract {
  final PaymentRemoteDataSourceContract _dataSource;

  PaymentRepoImpl(this._dataSource);

  @override
  Future<BaseResponse<CashOrderEntity>> createCashOrder(
    PaymentRequestModel requestModel,
  ) async {
    final response = await _dataSource.createCashOrder(requestModel);
    return switch (response) {
      SuccessBaseResponse<CashOrderResponseModel>() => SuccessBaseResponse(
        data: response.data.toEntity(),
      ),
      ErrorBaseResponse<CashOrderResponseModel>() => ErrorBaseResponse(
        exception: response.exception,
      ),
    };
  }

  @override
  Future<BaseResponse<CheckoutSessionEntity>> createCheckoutSession(
    PaymentRequestModel requestModel,
  ) async {
    final response = await _dataSource.createCheckoutSession(requestModel);
    return switch (response) {
      SuccessBaseResponse<CheckoutSessionResponseModel>() =>
        SuccessBaseResponse(data: response.data.toEntity()),
      ErrorBaseResponse<CheckoutSessionResponseModel>() => ErrorBaseResponse(
        exception: response.exception,
      ),
    };
  }
}
