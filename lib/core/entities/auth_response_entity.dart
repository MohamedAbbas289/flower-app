import 'package:equatable/equatable.dart';
import 'package:flower_app/core/entities/user_entity.dart';

class AuthResponseEntity extends Equatable {
  final String? message;
  final UserEntity? user;
  final String? token;

  const AuthResponseEntity({this.message, this.user, this.token});

  @override
  List<Object?> get props => [message, user, token];
}
