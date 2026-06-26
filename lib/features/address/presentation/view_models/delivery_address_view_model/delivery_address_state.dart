import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/address/domain/display_states/delivery_address_display.dart';

class DeliveryAddressState extends Equatable {
  final BaseState<DeliveryAddressDisplayState> deliveryAddressState;

  const DeliveryAddressState({
    this.deliveryAddressState = const BaseState(),
  });

  DeliveryAddressState copyWith({
    BaseState<DeliveryAddressDisplayState>? deliveryAddressState,
  }) {
    return DeliveryAddressState(
      deliveryAddressState: deliveryAddressState ?? this.deliveryAddressState,
    );
  }

  @override
  List<Object?> get props => [deliveryAddressState];
}
