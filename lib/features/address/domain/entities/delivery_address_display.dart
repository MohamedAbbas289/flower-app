import 'package:equatable/equatable.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

sealed class DeliveryAddressDisplayState extends Equatable {
  const DeliveryAddressDisplayState();

  @override
  List<Object?> get props => [];
}

class NoAddressDisplay extends DeliveryAddressDisplayState {
  const NoAddressDisplay();
}

class CurrentLocationDisplay extends DeliveryAddressDisplayState {
  final String label;

  const CurrentLocationDisplay(this.label);

  @override
  List<Object?> get props => [label];
}

class SavedAddressDisplay extends DeliveryAddressDisplayState {
  final AddressEntity address;
  final bool isNearest;

  const SavedAddressDisplay(this.address, {required this.isNearest});

  @override
  List<Object?> get props => [address, isNearest];
}
