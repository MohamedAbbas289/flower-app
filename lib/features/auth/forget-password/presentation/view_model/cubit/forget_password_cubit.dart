import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/values/app_strings.dart';

import '../../../domain/entities/forget_password_entity.dart';
import '../../../domain/usecase/forget_password_use_case.dart';
import '../states/forget_password_states.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordBaseState> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;

  ForgetPasswordCubit(this._forgetPasswordUseCase)
    : super(const ForgotPasswordInitial());

  String? _email;

  // ---------------------------------------------------------------------------
  // Step 1 — send reset-password email
  // ---------------------------------------------------------------------------
  Future<void> sendResetEmail(String email) async {
    _email = email;

    emit(const ForgotPasswordLoading());

    final result = await _forgetPasswordUseCase.forgotPassword(email);

    if (result is SuccessBaseResponse<ForgetPasswordEntity>) {
      emit(const ForgotPasswordSuccess());
      return;
    }

    if (result is ErrorBaseResponse<ForgetPasswordEntity>) {
      emit(ForgotPasswordFailure(_extractErrorMessage(result)));
    }
  }

  // ---------------------------------------------------------------------------
  // Step 2 — verify OTP code
  // ---------------------------------------------------------------------------
  Future<void> verifyOtpCode(String code) async {
    emit(const VerifyCodeLoading());

    final result = await _forgetPasswordUseCase.verifyCode(code);

    if (result is SuccessBaseResponse<ForgetPasswordEntity>) {
      emit(const VerifyCodeSuccess());
      return;
    }

    if (result is ErrorBaseResponse<ForgetPasswordEntity>) {
      emit(VerifyCodeFailure(_extractErrorMessage(result)));
    }
  }

  // ---------------------------------------------------------------------------
  // Step 2 (extra) — resend OTP code using the saved email
  // ---------------------------------------------------------------------------
  Future<void> resendOtpCode() async {
    if (_email == null) return;

    emit(const VerifyCodeLoading());

    final result = await _forgetPasswordUseCase.forgotPassword(_email!);

    if (result is SuccessBaseResponse<ForgetPasswordEntity>) {
      // Resend succeeded — emit success so the UI knows loading is done
      emit(const VerifyCodeSuccess());
      return;
    }

    if (result is ErrorBaseResponse<ForgetPasswordEntity>) {
      emit(VerifyCodeFailure(_extractErrorMessage(result)));
    }
  }

  // ---------------------------------------------------------------------------
  // Step 3 — reset the password
  // ---------------------------------------------------------------------------
  Future<void> resetPassword(String newPassword) async {
    // _email is guaranteed to be set by step 1
    if (_email == null) return;

    emit(const ResetPasswordLoading());

    final result = await _forgetPasswordUseCase.resetPassword(
      email: _email!,
      newPassword: newPassword,
    );

    if (result is SuccessBaseResponse<ForgetPasswordEntity>) {
      emit(const ResetPasswordSuccess());
      return;
    }

    if (result is ErrorBaseResponse<ForgetPasswordEntity>) {
      emit(ResetPasswordFailure(_extractErrorMessage(result)));
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Extracts the human-readable error message from an [ErrorBaseResponse].
  /// [ErrorBaseResponse.errorMessage] is always set by [BaseError.handleException],
  /// so we read it directly instead of casting to dynamic.
  String _extractErrorMessage(
    ErrorBaseResponse<ForgetPasswordEntity> response,
  ) {
    if (response.errorMessage.isNotEmpty) return response.errorMessage;
    return AppStrings.somethingWentWrong;
  }
}
