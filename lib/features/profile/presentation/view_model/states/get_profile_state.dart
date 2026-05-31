import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';

class GetProfileState extends Equatable {
  final BaseState<AuthResponseEntity> getProfileState;

  const GetProfileState({this.getProfileState = const BaseState()});

  GetProfileState copyWith({BaseState<AuthResponseEntity>? getProfileState}) {
    return GetProfileState(
      getProfileState: getProfileState ?? this.getProfileState,
    );
  }

  @override
  List<Object?> get props => [getProfileState];
}
