import 'package:equatable/equatable.dart';

enum ForgetPasswordRecoveryStep { forgotPassword, verifyCode, resetPassword }

class ForgetPasswordEntity extends Equatable {
  final ForgetPasswordRecoveryStep forgetPasswordRecoveryStep;
  final String? message;
  final String? info;
  final String? status;

  const ForgetPasswordEntity({
    required this.forgetPasswordRecoveryStep,
    this.message,
    this.info,
    this.status,
  });
}
