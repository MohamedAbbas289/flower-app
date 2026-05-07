import 'package:equatable/equatable.dart';

sealed class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordEvent extends ForgetPasswordEvent {
  final String email;

  const ForgotPasswordEvent(this.email);

  @override
  List<Object?> get props => [email];
}

class VerifyCodeEvent extends ForgetPasswordEvent {
  final String code;

  const VerifyCodeEvent(this.code);

  @override
  List<Object?> get props => [code];
}

class ResetPasswordEvent extends ForgetPasswordEvent {
  final String email;
  final String password;

  const ResetPasswordEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class ResendCodeEvent extends ForgetPasswordEvent {}
