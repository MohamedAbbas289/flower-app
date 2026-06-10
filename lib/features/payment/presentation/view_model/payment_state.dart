import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/payment/domain/entities/cash_order_entity.dart';
import 'package:flower_app/features/payment/domain/entities/checkout_session_entity.dart';

class PaymentState extends Equatable {
  final BaseState<CashOrderEntity> cashOrderState;
  final BaseState<CheckoutSessionEntity> checkoutSessionState;

  const PaymentState({
    this.cashOrderState = const BaseState(),
    this.checkoutSessionState = const BaseState(),
  });

  PaymentState copyWith({
    BaseState<CashOrderEntity>? cashOrderState,
    BaseState<CheckoutSessionEntity>? checkoutSessionState,
  }) {
    return PaymentState(
      cashOrderState: cashOrderState ?? this.cashOrderState,
      checkoutSessionState: checkoutSessionState ?? this.checkoutSessionState,
    );
  }

  @override
  List<Object?> get props => [cashOrderState, checkoutSessionState];
}
