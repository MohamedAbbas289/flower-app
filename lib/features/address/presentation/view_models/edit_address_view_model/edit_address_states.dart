import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/add_address/domain/entities/address_entity.dart';

class EditAddressStates extends Equatable {
  final BaseState<List<AddressEntity>> editAddressState;

  const EditAddressStates({
    this.editAddressState = const BaseState(),
  });

  EditAddressStates copyWith({
    BaseState<List<AddressEntity>>? editAddressState,
  }) {
    return EditAddressStates(
      editAddressState: editAddressState ?? this.editAddressState,
    );
  }

  @override
  List<Object?> get props => [editAddressState];
}