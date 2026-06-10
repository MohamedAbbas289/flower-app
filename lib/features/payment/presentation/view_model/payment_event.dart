import 'package:equatable/equatable.dart';
import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class CreateCashOrderEvent extends PaymentEvent {
  final String cartId;
  final PaymentRequestModel requestModel;

  const CreateCashOrderEvent({
    required this.cartId,
    required this.requestModel,
  });

  @override
  List<Object?> get props => [cartId, requestModel];
}

class CreateCheckoutSessionEvent extends PaymentEvent {
  final String cartId;
  final PaymentRequestModel requestModel;

  const CreateCheckoutSessionEvent({
    required this.cartId,
    required this.requestModel,
  });

  @override
  List<Object?> get props => [cartId, requestModel];
}
