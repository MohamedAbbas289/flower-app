import 'package:flower_app/features/auth/presentation/view_models/forget_password_view_model/forget_password_states.dart';
import 'package:test/test.dart';

void main() {
  // =========================
  // FORGOT PASSWORD STATES
  // =========================
  group('ForgotPassword states', () {
    test('ForgotPasswordInitial is a ForgetPasswordBaseState', () {
      const state = ForgotPasswordInitial();
      expect(state, isA<ForgetPasswordBaseState>());
    });

    test('ForgotPasswordLoading is a ForgetPasswordBaseState', () {
      const state = ForgotPasswordLoading();
      expect(state, isA<ForgetPasswordBaseState>());
    });

    test('ForgotPasswordSuccess is a ForgetPasswordBaseState', () {
      const state = ForgotPasswordSuccess();
      expect(state, isA<ForgetPasswordBaseState>());
    });

    test('ForgotPasswordFailure carries error message', () {
      const state = ForgotPasswordFailure('email error');
      expect(state, isA<ForgetPasswordBaseState>());
      expect(state.error, 'email error');
    });

    test('two ForgotPasswordFailure with same error are equal', () {
      const a = ForgotPasswordFailure('err');
      const b = ForgotPasswordFailure('err');
      expect(a, equals(b));
    });

    test('two ForgotPasswordFailure with different errors are not equal', () {
      const a = ForgotPasswordFailure('err1');
      const b = ForgotPasswordFailure('err2');
      expect(a, isNot(equals(b)));
    });
  });

  // =========================
  // VERIFY CODE STATES
  // =========================
  group('VerifyCode states', () {
    test('VerifyCodeLoading is a ForgetPasswordBaseState', () {
      const state = VerifyCodeLoading();
      expect(state, isA<ForgetPasswordBaseState>());
    });

    test('VerifyCodeSuccess is a ForgetPasswordBaseState', () {
      const state = VerifyCodeSuccess();
      expect(state, isA<ForgetPasswordBaseState>());
    });

    test('VerifyCodeFailure carries error message', () {
      const state = VerifyCodeFailure('invalid code');
      expect(state, isA<ForgetPasswordBaseState>());
      expect(state.error, 'invalid code');
    });

    test('two VerifyCodeFailure with same error are equal', () {
      const a = VerifyCodeFailure('err');
      const b = VerifyCodeFailure('err');
      expect(a, equals(b));
    });

    test('two VerifyCodeFailure with different errors are not equal', () {
      const a = VerifyCodeFailure('err1');
      const b = VerifyCodeFailure('err2');
      expect(a, isNot(equals(b)));
    });
  });

  // =========================
  // RESET PASSWORD STATES
  // =========================
  group('ResetPassword states', () {
    test('ResetPasswordLoading is a ForgetPasswordBaseState', () {
      const state = ResetPasswordLoading();
      expect(state, isA<ForgetPasswordBaseState>());
    });

    test('ResetPasswordSuccess is a ForgetPasswordBaseState', () {
      const state = ResetPasswordSuccess();
      expect(state, isA<ForgetPasswordBaseState>());
    });

    test('ResetPasswordFailure carries error message', () {
      const state = ResetPasswordFailure('reset failed');
      expect(state, isA<ForgetPasswordBaseState>());
      expect(state.error, 'reset failed');
    });

    test('two ResetPasswordFailure with same error are equal', () {
      const a = ResetPasswordFailure('err');
      const b = ResetPasswordFailure('err');
      expect(a, equals(b));
    });

    test('two ResetPasswordFailure with different errors are not equal', () {
      const a = ResetPasswordFailure('err1');
      const b = ResetPasswordFailure('err2');
      expect(a, isNot(equals(b)));
    });
  });

  // =========================
  // STATES ARE DISTINCT TYPES
  // =========================
  group('State type distinction', () {
    test('Loading states are not equal across steps', () {
      const forgot = ForgotPasswordLoading();
      const verify = VerifyCodeLoading();
      const reset = ResetPasswordLoading();

      expect(forgot, isNot(equals(verify)));
      expect(verify, isNot(equals(reset)));
      expect(forgot, isNot(equals(reset)));
    });

    test('Success states are not equal across steps', () {
      const forgot = ForgotPasswordSuccess();
      const verify = VerifyCodeSuccess();
      const reset = ResetPasswordSuccess();

      expect(forgot, isNot(equals(verify)));
      expect(verify, isNot(equals(reset)));
      expect(forgot, isNot(equals(reset)));
    });
  });
}
