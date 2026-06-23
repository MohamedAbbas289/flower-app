import 'package:equatable/equatable.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';

sealed class DeliveryAddressDisplay extends Equatable {
  const DeliveryAddressDisplay();

  @override
  List<Object?> get props => [];
}

class NoAddressDisplay extends DeliveryAddressDisplay {
  const NoAddressDisplay();
}

class CurrentLocationDisplay extends DeliveryAddressDisplay {
  final String label;

  const CurrentLocationDisplay(this.label);

  @override
  List<Object?> get props => [label];
}

class SavedAddressDisplay extends DeliveryAddressDisplay {
  final AddressEntity address;
  final bool isNearest;

  const SavedAddressDisplay(this.address, {required this.isNearest});

  @override
  List<Object?> get props => [address, isNearest];
}
