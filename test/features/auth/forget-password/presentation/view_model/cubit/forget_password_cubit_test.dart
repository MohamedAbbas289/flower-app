import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/auth/forget-password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/auth/forget-password/domain/usecase/forget_password_use_case.dart';
import 'package:flower_app/features/auth/forget-password/presentation/view_model/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/auth/forget-password/presentation/view_model/states/forget_password_states.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'forget_password_cubit_test.mocks.dart';


@GenerateMocks([ForgetPasswordUseCase])
void main() {
  late ForgetPasswordCubit cubit;
  late MockForgetPasswordUseCase mockUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<ForgetPasswordEntity>>(
      SuccessBaseResponse<ForgetPasswordEntity>(
        data: ForgetPasswordEntity(
          forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forgotPassword,
          message: 'dummy',
        ),
      ),
    );

    provideDummy<BaseResponse<ForgetPasswordEntity>>(
      ErrorBaseResponse<ForgetPasswordEntity>(exception: Exception('dummy')),
    );
  });

  final tForgotEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forgotPassword,
    message: 'Success',
    info: 'Code sent',
  );

  final tVerifyEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.verifyCode,
    message: 'verified',
  );

  final tResetEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.resetPassword,
    message: 'reset done',
  );

  setUp(() {
    mockUseCase = MockForgetPasswordUseCase();
    cubit = ForgetPasswordCubit(mockUseCase);
  });

  tearDown(() => cubit.close());

  // =========================
  // SEND RESET EMAIL
  // =========================
  group('sendResetEmail', () {
    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'emits [ForgotPasswordLoading, ForgotPasswordSuccess] on success',
      build: () {
        when(
          mockUseCase.forgotPassword(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tForgotEntity));
        return cubit;
      },
      act: (c) => c.sendResetEmail('test@mail.com'),
      expect: () => [
        isA<ForgotPasswordLoading>(),
        isA<ForgotPasswordSuccess>(),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'emits [ForgotPasswordLoading, ForgotPasswordFailure] on failure',
      build: () {
        when(mockUseCase.forgotPassword(any)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('error')),
        );
        return cubit;
      },
      act: (c) => c.sendResetEmail('test@mail.com'),
      expect: () => [
        isA<ForgotPasswordLoading>(),
        isA<ForgotPasswordFailure>(),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'ForgotPasswordFailure carries error message',
      build: () {
        when(mockUseCase.forgotPassword(any)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('error')),
        );
        return cubit;
      },
      act: (c) => c.sendResetEmail('test@mail.com'),
      expect: () => [
        isA<ForgotPasswordLoading>(),
        isA<ForgotPasswordFailure>().having(
          (s) => s.error,
          'error',
          isNotEmpty,
        ),
      ],
    );
  });

  // =========================
  // VERIFY OTP CODE
  // =========================
  group('verifyOtpCode', () {
    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'emits [VerifyCodeLoading, VerifyCodeSuccess] on success',
      build: () {
        when(
          mockUseCase.verifyCode(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tVerifyEntity));
        return cubit;
      },
      act: (c) => c.verifyOtpCode('1234'),
      expect: () => [isA<VerifyCodeLoading>(), isA<VerifyCodeSuccess>()],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'emits [VerifyCodeLoading, VerifyCodeFailure] on failure',
      build: () {
        when(mockUseCase.verifyCode(any)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('error')),
        );
        return cubit;
      },
      act: (c) => c.verifyOtpCode('0000'),
      expect: () => [isA<VerifyCodeLoading>(), isA<VerifyCodeFailure>()],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'VerifyCodeFailure carries error message',
      build: () {
        when(mockUseCase.verifyCode(any)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('error')),
        );
        return cubit;
      },
      act: (c) => c.verifyOtpCode('0000'),
      expect: () => [
        isA<VerifyCodeLoading>(),
        isA<VerifyCodeFailure>().having((s) => s.error, 'error', isNotEmpty),
      ],
    );
  });

  // =========================
  // RESEND OTP CODE
  // =========================
  group('resendOtpCode', () {
    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'does nothing if email was never set',
      build: () => cubit,
      act: (c) => c.resendOtpCode(),
      expect: () => [],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'emits [VerifyCodeLoading, VerifyCodeSuccess] on success',
      build: () {
        when(
          mockUseCase.forgotPassword(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tForgotEntity));
        return cubit;
      },
      // sendResetEmail stores the email so resendOtpCode can reuse it
      act: (c) async {
        await c.sendResetEmail('test@mail.com');
        await c.resendOtpCode();
      },
      expect: () => [
        isA<ForgotPasswordLoading>(),
        isA<ForgotPasswordSuccess>(),
        isA<VerifyCodeLoading>(),
        isA<VerifyCodeSuccess>(),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'emits [VerifyCodeLoading, VerifyCodeFailure] on failure',
      build: () {
        when(
          mockUseCase.forgotPassword(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tForgotEntity));
        return cubit;
      },
      act: (c) async {
        await c.sendResetEmail('test@mail.com');

        when(mockUseCase.forgotPassword(any)).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('resend failed')),
        );

        await c.resendOtpCode();
      },
      expect: () => [
        isA<ForgotPasswordLoading>(),
        isA<ForgotPasswordSuccess>(),
        isA<VerifyCodeLoading>(),
        isA<VerifyCodeFailure>(),
      ],
    );
  });

  // =========================
  // RESET PASSWORD
  // =========================
  group('resetPassword', () {
    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'does nothing if email was never set',
      build: () => cubit,
      act: (c) => c.resetPassword('NewPass123!'),
      expect: () => [],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'emits [ResetPasswordLoading, ResetPasswordSuccess] on success',
      build: () {
        when(
          mockUseCase.forgotPassword(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tForgotEntity));
        when(
          mockUseCase.resetPassword(
            email: anyNamed('email'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tResetEntity));
        return cubit;
      },
      act: (c) async {
        await c.sendResetEmail('test@mail.com');
        await c.resetPassword('NewPass123!');
      },
      expect: () => [
        isA<ForgotPasswordLoading>(),
        isA<ForgotPasswordSuccess>(),
        isA<ResetPasswordLoading>(),
        isA<ResetPasswordSuccess>(),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'emits [ResetPasswordLoading, ResetPasswordFailure] on failure',
      build: () {
        when(
          mockUseCase.forgotPassword(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tForgotEntity));
        when(
          mockUseCase.resetPassword(
            email: anyNamed('email'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('reset error')),
        );
        return cubit;
      },
      act: (c) async {
        await c.sendResetEmail('test@mail.com');
        await c.resetPassword('NewPass123!');
      },
      expect: () => [
        isA<ForgotPasswordLoading>(),
        isA<ForgotPasswordSuccess>(),
        isA<ResetPasswordLoading>(),
        isA<ResetPasswordFailure>(),
      ],
    );

    blocTest<ForgetPasswordCubit, ForgetPasswordBaseState>(
      'ResetPasswordFailure carries error message',
      build: () {
        when(
          mockUseCase.forgotPassword(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tForgotEntity));
        when(
          mockUseCase.resetPassword(
            email: anyNamed('email'),
            newPassword: anyNamed('newPassword'),
          ),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('reset error')),
        );
        return cubit;
      },
      act: (c) async {
        await c.sendResetEmail('test@mail.com');
        await c.resetPassword('NewPass123!');
      },
      expect: () => [
        isA<ForgotPasswordLoading>(),
        isA<ForgotPasswordSuccess>(),
        isA<ResetPasswordLoading>(),
        isA<ResetPasswordFailure>().having((s) => s.error, 'error', isNotEmpty),
      ],
    );
  });
}
