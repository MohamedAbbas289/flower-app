import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/delivery_location/domain/entities/delivery_address_display.dart';

class DeliveryAddressState extends Equatable {
  final BaseState<DeliveryAddressDisplay> deliveryAddressState;

  const DeliveryAddressState({
    this.deliveryAddressState = const BaseState(),
  });

  DeliveryAddressState copyWith({
    BaseState<DeliveryAddressDisplay>? deliveryAddressState,
  }) {
    return DeliveryAddressState(
      deliveryAddressState: deliveryAddressState ?? this.deliveryAddressState,
    );
  }

  @override
  List<Object?> get props => [deliveryAddressState];
}
