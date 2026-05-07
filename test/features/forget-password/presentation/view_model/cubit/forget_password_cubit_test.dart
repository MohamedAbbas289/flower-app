import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget-password/domain/usecase/forget_password_use_case.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/cubit/forget_password_cubit.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/events/forget_password_events.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/states/forget_password_states.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'forget_password_cubit_test.mocks.dart';

@GenerateMocks([ForgetPasswordUseCase])
void main() {
  late ForgetPasswordCubit cubit;
  late MockForgetPasswordUseCase useCase;
  setUpAll(() {
    provideDummy<BaseResponse<ForgetPasswordEntity>>(
      SuccessBaseResponse<ForgetPasswordEntity>(
        data: ForgetPasswordEntity(
          forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forgotPassword,
          message: "dummy",
        ),
      ),
    );

    provideDummy<BaseResponse<ForgetPasswordEntity>>(
      ErrorBaseResponse<ForgetPasswordEntity>(exception: Exception("dummy")),
    );
  });

  final entity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forgotPassword,
    message: "Success",
    info: "Code sent",
  );

  final exception = Exception("error");

  setUp(() {
    useCase = MockForgetPasswordUseCase();
    cubit = ForgetPasswordCubit(useCase);
  });

  tearDown(() => cubit.close());

  group("ForgotPassword", () {
    blocTest(
      "success",
      build: () {
        when(
          useCase.forgotPassword(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: entity));
        return cubit;
      },
      act: (c) => c.onEvent(ForgotPasswordEvent("mail@test.com")),
      expect: () => [
        isA<ForgetPasswordState>().having((s) => s.isLoading, "loading", true),

        isA<ForgetPasswordState>()
            .having((s) => s.isLoading, "loading", false)
            .having((s) => s.data, "data", entity),
      ],
    );

    blocTest(
      "failure",
      build: () {
        when(
          useCase.forgotPassword(any),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: exception));
        return cubit;
      },
      act: (c) => c.onEvent(ForgotPasswordEvent("mail@test.com")),
      expect: () => [
        isA<ForgetPasswordState>().having((s) => s.isLoading, "loading", true),

        isA<ForgetPasswordState>()
            .having((s) => s.isLoading, "loading", false)
            .having((s) => s.error, "error", isNotNull),
      ],
    );
  });

  group("VerifyCode", () {
    blocTest(
      "success",
      build: () {
        when(
          useCase.verifyCode(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: entity));
        return cubit;
      },
      act: (c) => c.onEvent(VerifyCodeEvent("123")),
      expect: () => [
        isA<ForgetPasswordState>().having((s) => s.isLoading, "loading", true),

        isA<ForgetPasswordState>()
            .having((s) => s.isLoading, "loading", false)
            .having((s) => s.data, "data", entity),
      ],
    );

    blocTest(
      "failure",
      build: () {
        when(
          useCase.verifyCode(any),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: exception));
        return cubit;
      },
      act: (c) => c.onEvent(VerifyCodeEvent("123")),
      expect: () => [
        isA<ForgetPasswordState>().having((s) => s.isLoading, "loading", true),

        isA<ForgetPasswordState>()
            .having((s) => s.isLoading, "loading", false)
            .having((s) => s.error, "error", isNotNull),
      ],
    );
  });

  group("ResetPassword", () {
    blocTest(
      "success",
      build: () {
        when(
          useCase.resetPassword(
            email: anyNamed("email"),
            newPassword: anyNamed("newPassword"),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: entity));
        return cubit;
      },
      act: (c) => c.onEvent(ResetPasswordEvent("mail@test.com", "123456")),
      expect: () => [
        isA<ForgetPasswordState>().having((s) => s.isLoading, "loading", true),

        isA<ForgetPasswordState>()
            .having((s) => s.isLoading, "loading", false)
            .having((s) => s.data, "data", entity),
      ],
    );

    blocTest(
      "failure",
      build: () {
        when(
          useCase.resetPassword(
            email: anyNamed("email"),
            newPassword: anyNamed("newPassword"),
          ),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: exception));
        return cubit;
      },
      act: (c) => c.onEvent(ResetPasswordEvent("mail@test.com", "123456")),
      expect: () => [
        isA<ForgetPasswordState>().having((s) => s.isLoading, "loading", true),

        isA<ForgetPasswordState>()
            .having((s) => s.isLoading, "loading", false)
            .having((s) => s.error, "error", isNotNull),
      ],
    );
  });
}
