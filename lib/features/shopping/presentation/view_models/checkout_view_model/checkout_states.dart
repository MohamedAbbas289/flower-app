import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/payment_method.dart';

sealed class PlaceOrderResult extends Equatable {
  const PlaceOrderResult();
}

class CashOrderPlaced extends PlaceOrderResult {
  final String orderNumber;
  const CashOrderPlaced(this.orderNumber);

  @override
  List<Object?> get props => [orderNumber];
}

class StripeSessionCreated extends PlaceOrderResult {
  final String sessionUrl;
  const StripeSessionCreated(this.sessionUrl);

  @override
  List<Object?> get props => [sessionUrl];
}

class CheckoutStates extends Equatable {
  final BaseState<List<AddressEntity>> addressesState;
  final AddressEntity? selectedAddress;
  final PaymentMethod paymentMethod;
  final bool isGift;
  final BaseState<PlaceOrderResult> placeOrderState;

  const CheckoutStates({
    this.addressesState = const BaseState(),
    this.selectedAddress,
    this.paymentMethod = PaymentMethod.cash,
    this.isGift = false,
    this.placeOrderState = const BaseState(),
  });

  CheckoutStates copyWith({
    BaseState<List<AddressEntity>>? addressesState,
    AddressEntity? selectedAddress,
    PaymentMethod? paymentMethod,
    bool? isGift,
    BaseState<PlaceOrderResult>? placeOrderState,
  }) {
    return CheckoutStates(
      addressesState: addressesState ?? this.addressesState,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isGift: isGift ?? this.isGift,
      placeOrderState: placeOrderState ?? this.placeOrderState,
    );
  }

  @override
  List<Object?> get props => [
    addressesState,
    selectedAddress,
    paymentMethod,
    isGift,
    placeOrderState,
  ];
}
