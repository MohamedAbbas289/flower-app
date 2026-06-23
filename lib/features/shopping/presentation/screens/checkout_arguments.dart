import 'package:equatable/equatable.dart';

class CheckoutArguments extends Equatable {
  final int subTotal;
  final int deliveryFee;
  final int total;

  const CheckoutArguments({
    required this.subTotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  List<Object?> get props => [subTotal, deliveryFee, total];
}
