import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';

class SignupStates extends Equatable {
  final BaseState<AuthResponseEntity> signupState;
  const SignupStates({this.signupState = const BaseState()});
  SignupStates copyWith({BaseState<AuthResponseEntity>? signupState}) {
    return SignupStates(signupState: signupState ?? this.signupState);
  }

  @override
  List<Object> get props => [signupState];
}
