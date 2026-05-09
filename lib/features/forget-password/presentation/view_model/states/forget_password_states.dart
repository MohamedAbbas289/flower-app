import 'package:equatable/equatable.dart';

// ---------------------------------------------------------------------------
// Base state — every forget-password sub-state extends this.
// Props are empty by default so states without data (Loading, Success)
// are compared by runtimeType only, which is the correct behaviour.
// Failure states override props to carry the error message.
// ---------------------------------------------------------------------------
abstract class ForgetPasswordBaseState extends Equatable {
  const ForgetPasswordBaseState();

  @override
  List<Object?> get props => [];
}

// ---------------------------------------------------------------------------
// Forgot-password (step 1 — send email)
// ---------------------------------------------------------------------------
class ForgotPasswordInitial extends ForgetPasswordBaseState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgetPasswordBaseState {
  const ForgotPasswordLoading();
}

class ForgotPasswordSuccess extends ForgetPasswordBaseState {
  const ForgotPasswordSuccess();
}

class ForgotPasswordFailure extends ForgetPasswordBaseState {
  final String error;

  const ForgotPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// ---------------------------------------------------------------------------
// Verify-code (step 2)
// ---------------------------------------------------------------------------
class VerifyCodeLoading extends ForgetPasswordBaseState {
  const VerifyCodeLoading();
}

class VerifyCodeSuccess extends ForgetPasswordBaseState {
  const VerifyCodeSuccess();
}

class VerifyCodeFailure extends ForgetPasswordBaseState {
  final String error;

  const VerifyCodeFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// ---------------------------------------------------------------------------
// Reset-password (step 3)
// ---------------------------------------------------------------------------
class ResetPasswordLoading extends ForgetPasswordBaseState {
  const ResetPasswordLoading();
}

class ResetPasswordSuccess extends ForgetPasswordBaseState {
  const ResetPasswordSuccess();
}

class ResetPasswordFailure extends ForgetPasswordBaseState {
  final String error;

  const ResetPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
