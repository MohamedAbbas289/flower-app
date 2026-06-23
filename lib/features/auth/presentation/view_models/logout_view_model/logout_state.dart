import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';

class LogoutState extends Equatable {
  final BaseState<void> logoutState;

  const LogoutState({this.logoutState = const BaseState()});

  LogoutState copyWith({BaseState<void>? logoutState}) {
    return LogoutState(logoutState: logoutState ?? this.logoutState);
  }

  @override
  List<Object?> get props => [logoutState];
}
