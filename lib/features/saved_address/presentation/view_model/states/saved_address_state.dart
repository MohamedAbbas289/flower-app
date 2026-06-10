import 'package:equatable/equatable.dart';

import '../../../../../config/base_state/base_state.dart';
import '../../../../../core/models/auth_response.dart';

class SavedAddressState extends Equatable{
  final BaseState<AuthResponse> getSavedAddressState;
  const SavedAddressState({this.getSavedAddressState = const BaseState()});
  SavedAddressState copyWith({BaseState<AuthResponse>? getSavedAddressState}) {
    return SavedAddressState(
      getSavedAddressState: getSavedAddressState ?? this.getSavedAddressState,
    );
  }

  @override
  List<Object?> get props => [getSavedAddressState];


}