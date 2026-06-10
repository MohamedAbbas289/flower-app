import 'package:flower_app/features/payment/api/request_models/payment_request_model.dart';

class PaymentViewArguments {
  final String cartId;
  final PaymentRequestModel requestModel;
  final double subTotal;
  final double deliveryFee;
  final double total;

  const PaymentViewArguments({
    required this.cartId,
    required this.requestModel,
    required this.subTotal,
    required this.deliveryFee,
    required this.total,
  });
}
