import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';

class LoginState extends Equatable {
  final BaseState<AuthResponseEntity> loginState;

  const LoginState({this.loginState = const BaseState()});

  LoginState copyWith({BaseState<AuthResponseEntity>? loginState}) {
    return LoginState(loginState: loginState ?? this.loginState);
  }

  @override
  List<Object?> get props => [loginState];
}
