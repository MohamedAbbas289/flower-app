import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';

class LoginStates extends Equatable {
  final BaseState<AuthResponseEntity> loginState;
  final String? emailError;
  final String? passwordError;

  const LoginStates({
    this.loginState = const BaseState(),
    this.emailError,
    this.passwordError,
  });

  LoginStates copyWith({
    BaseState<AuthResponseEntity>? loginState,
    String? emailError,
    String? passwordError,
  }) {
    return LoginStates(
      loginState: loginState ?? this.loginState,
      emailError: emailError,
      passwordError: passwordError,
    );
  }

  @override
  List<Object?> get props => [loginState, emailError, passwordError];
}
