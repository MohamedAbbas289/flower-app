import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';

class SignupState extends Equatable {
  final BaseState<AuthResponseEntity> signupState;
  final bool autoValidate;

  const SignupState({
    this.signupState = const BaseState(),
    this.autoValidate = false,
  });
  SignupState copyWith({
    BaseState<AuthResponseEntity>? signupState,
    bool? autoValidate,
  }) {
    return SignupState(
      signupState: signupState ?? this.signupState,
      autoValidate: autoValidate ?? this.autoValidate,
    );
  }

  @override
  List<Object> get props => [signupState, autoValidate];
}
