import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';

class SignupState extends Equatable {
  final BaseState<AuthResponseEntity> signupState;
  const SignupState({this.signupState = const BaseState()});
  SignupState copyWith({BaseState<AuthResponseEntity>? signupState}) {
    return SignupState(signupState: signupState ?? this.signupState);
  }

  @override
  List<Object> get props => [signupState];
}
