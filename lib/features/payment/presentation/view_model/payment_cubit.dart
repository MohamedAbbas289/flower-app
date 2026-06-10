import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';
import 'package:flower_app/features/payment/domain/use_cases/create_cash_order_use_case.dart';
import 'package:flower_app/features/payment/domain/use_cases/get_checkout_session_use_case.dart';
import 'package:flower_app/features/payment/presentation/view_model/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final CreateCashOrderUseCase _createCashOrderUseCase;
  final GetCheckoutSessionUseCase _getCheckoutSessionUseCase;

  PaymentCubit(this._createCashOrderUseCase, this._getCheckoutSessionUseCase)
    : super(const PaymentState());

  Future<void> createCashOrder({
    required PaymentRequestModel requestModel,
  }) async {
    emit(state.copyWith(cashOrderState: BaseState.loading()));

    final response = await _createCashOrderUseCase(requestModel: requestModel);

    switch (response) {
      case SuccessBaseResponse<CashOrderEntity>():
        emit(state.copyWith(cashOrderState: BaseState.success(response.data)));
      case ErrorBaseResponse<CashOrderEntity>():
        emit(
          state.copyWith(
            cashOrderState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }

  Future<void> createCheckoutSession({
    required PaymentRequestModel requestModel,
  }) async {
    emit(state.copyWith(checkoutSessionState: BaseState.loading()));

    final response = await _getCheckoutSessionUseCase(
      requestModel: requestModel,
    );

    switch (response) {
      case SuccessBaseResponse<CheckoutSessionEntity>():
        emit(
          state.copyWith(
            checkoutSessionState: BaseState.success(response.data),
          ),
        );
      case ErrorBaseResponse<CheckoutSessionEntity>():
        emit(
          state.copyWith(
            checkoutSessionState: BaseState.error(response.errorMessage),
          ),
        );
    }
  }
}
