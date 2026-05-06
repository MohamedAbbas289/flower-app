sealed class ForgetPasswordEvent {}

class ForgotPasswordEvent extends ForgetPasswordEvent {
  final String email;
  ForgotPasswordEvent(this.email);
}

class VerifyCodeEvent extends ForgetPasswordEvent {
  final String code;
  VerifyCodeEvent(this.code);
}

class ResetPasswordEvent extends ForgetPasswordEvent {
  final String email;
  final String password;

  ResetPasswordEvent(this.email, this.password);
}
