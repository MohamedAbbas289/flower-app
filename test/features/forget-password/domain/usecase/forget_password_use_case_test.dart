import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget-password/domain/repositories/forget_password_repo.dart';
import 'package:flower_app/features/forget-password/domain/usecase/forget_password_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'forget_password_use_case_test.mocks.dart';

@GenerateMocks([ForgetPasswordRepo])
void main() {
  late ForgetPasswordUseCase useCase;
  late MockForgetPasswordRepo mockRepo;

  setUpAll(() {
    provideDummy<BaseResponse<ForgetPasswordEntity>>(
      SuccessBaseResponse(
        data: ForgetPasswordEntity(
          forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forgotPassword,
          message: "dummy",
        ),
      ),
    );
  });

  final tForgotEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forgotPassword,
    message: "Success",
    info: "Code sent to your email",
  );

  final tVerifyEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.verifyCode,
    status: "Success",
    message: "Code verified successfully",
  );

  final tResetEntity = ForgetPasswordEntity(
    forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.resetPassword,
    status: "Success",
    message: "Password changed successfully",
  );

  final tException = Exception("Something went wrong. Please try again later.");

  setUp(() {
    mockRepo = MockForgetPasswordRepo();
    useCase = ForgetPasswordUseCase(mockRepo);
  });

  // forgotPassword
  group("forgotPassword", () {
    group("Success Cases", () {
      test("delegates to repo and returns SuccessBaseResponse", () async {
        // Arrange
        when(
          mockRepo.forgotPassword(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tForgotEntity));

        // Act
        final result = await useCase.forgotPassword("test@example.com");

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as SuccessBaseResponse<ForgetPasswordEntity>).data,
          tForgotEntity,
        );
        verify(mockRepo.forgotPassword("test@example.com")).called(1);
        verifyNoMoreInteractions(mockRepo);
      });
    });

    group("Failure Cases", () {
      test("returns ErrorBaseResponse when repo returns error", () async {
        // Arrange
        when(
          mockRepo.forgotPassword(any),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

        // Act
        final result = await useCase.forgotPassword("test@example.com");

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
          isNotEmpty,
        );
        verify(mockRepo.forgotPassword("test@example.com")).called(1);
        verifyNoMoreInteractions(mockRepo);
      });
    });
  });

  // verifyCode
  group("verifyCode", () {
    group("Success Cases", () {
      test("delegates to repo and returns SuccessBaseResponse", () async {
        // Arrange
        when(
          mockRepo.verifyCode(any),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tVerifyEntity));

        // Act
        final result = await useCase.verifyCode("123456");

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as SuccessBaseResponse<ForgetPasswordEntity>).data,
          tVerifyEntity,
        );
        verify(mockRepo.verifyCode("123456")).called(1);
        verifyNoMoreInteractions(mockRepo);
      });
    });

    group("Failure Cases", () {
      test("returns ErrorBaseResponse when repo returns error", () async {
        // Arrange
        when(
          mockRepo.verifyCode(any),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

        // Act
        final result = await useCase.verifyCode("wrong_code");

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
          isNotEmpty,
        );
        verify(mockRepo.verifyCode("wrong_code")).called(1);
        verifyNoMoreInteractions(mockRepo);
      });
    });
  });

  // resetPassword
  group("resetPassword", () {
    group("Success Cases", () {
      test("delegates to repo and returns SuccessBaseResponse", () async {
        // Arrange
        when(
          mockRepo.resetPassword(
            email: anyNamed("email"),
            newPassword: anyNamed("newPassword"),
          ),
        ).thenAnswer((_) async => SuccessBaseResponse(data: tResetEntity));

        // Act
        final result = await useCase.resetPassword(
          email: "test@example.com",
          newPassword: "NewPass123!",
        );

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as SuccessBaseResponse<ForgetPasswordEntity>).data,
          tResetEntity,
        );
        verify(
          mockRepo.resetPassword(
            email: "test@example.com",
            newPassword: "NewPass123!",
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepo);
      });
    });

    group("Failure Cases", () {
      test("returns ErrorBaseResponse when repo returns error", () async {
        // Arrange
        when(
          mockRepo.resetPassword(
            email: anyNamed("email"),
            newPassword: anyNamed("newPassword"),
          ),
        ).thenAnswer((_) async => ErrorBaseResponse(exception: tException));

        // Act
        final result = await useCase.resetPassword(
          email: "test@example.com",
          newPassword: "NewPass123!",
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
          isNotEmpty,
        );
        verify(
          mockRepo.resetPassword(
            email: "test@example.com",
            newPassword: "NewPass123!",
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepo);
      });
    });
  });
}
