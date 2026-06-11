import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';

class SavedAddressStates extends Equatable {
  final BaseState<List<AddressEntity>> getAddressesState;
  final BaseState<bool> deleteAddressState;

  const SavedAddressStates({
    this.getAddressesState = const BaseState(),
    this.deleteAddressState = const BaseState(),
  });

  SavedAddressStates copyWith({
    BaseState<List<AddressEntity>>? getAddressesState,
    BaseState<bool>? deleteAddressState,
  }) {
    return SavedAddressStates(
      getAddressesState: getAddressesState ?? this.getAddressesState,
      deleteAddressState: deleteAddressState ?? this.deleteAddressState,
    );
  }

  @override
  List<Object?> get props => [getAddressesState, deleteAddressState];
}