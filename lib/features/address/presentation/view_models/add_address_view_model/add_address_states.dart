import 'package:equatable/equatable.dart';

import '../../../../../config/base_state/base_state.dart';
import '../../../domain/entities/address_entity.dart';

class AddAddressStates extends Equatable {
  final BaseState<List<AddressEntity>> addAddressState;

  const AddAddressStates({this.addAddressState = const BaseState()});

  AddAddressStates copyWith({BaseState<List<AddressEntity>>? addAddressState}) {
    return AddAddressStates(
      addAddressState: addAddressState ?? this.addAddressState,
    );
  }

  @override
  List<Object?> get props => [addAddressState];
}
