import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/payment_method.dart';

sealed class CheckoutEvent {
  const CheckoutEvent();
}

class LoadCheckoutDataEvent extends CheckoutEvent {
  const LoadCheckoutDataEvent();
}

class SelectAddressEvent extends CheckoutEvent {
  final AddressEntity address;
  const SelectAddressEvent(this.address);
}

class SelectPaymentMethodEvent extends CheckoutEvent {
  final PaymentMethod method;
  const SelectPaymentMethodEvent(this.method);
}

class ToggleGiftEvent extends CheckoutEvent {
  final bool value;
  const ToggleGiftEvent(this.value);
}

class PlaceOrderEvent extends CheckoutEvent {
  final String? giftName;
  final String? giftPhone;
  const PlaceOrderEvent({this.giftName, this.giftPhone});
}
