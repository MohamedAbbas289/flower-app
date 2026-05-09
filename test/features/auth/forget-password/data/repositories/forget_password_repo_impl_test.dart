import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/auth/forget-password/data/data_source/forget_password_remote_data_source.dart';
import 'package:flower_app/features/auth/forget-password/data/repositories/forget_password_repo_impl.dart';
import 'package:flower_app/features/auth/forget-password/domain/entities/forget_password_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'forget_password_repo_impl_test.mocks.dart';


@GenerateMocks([ForgetPasswordRemoteDataSource])
void main() {
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

  late ForgetPasswordRepoImpl repo;
  late MockForgetPasswordRemoteDataSource mockRemote;

  final tEntity = ForgetPasswordEntity(
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

  setUp(() {
    mockRemote = MockForgetPasswordRemoteDataSource();
    repo = ForgetPasswordRepoImpl(mockRemote);
  });

  // =========================
  // FORGOT PASSWORD
  // =========================
  group("forgotPassword", () {
    test("success", () async {
      when(
        mockRemote.forgotPassword(any),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

      final result = await repo.forgotPassword("test@test.com");

      expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());

      final success = result as SuccessBaseResponse<ForgetPasswordEntity>;
      expect(success.data, tEntity);
    });

    test("error", () async {
      when(mockRemote.forgotPassword(any)).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception("error")),
      );

      final result = await repo.forgotPassword("test@test.com");

      expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
    });
  });

  // =========================
  // VERIFY CODE
  // =========================
  group("verifyCode", () {
    test("success", () async {
      when(
        mockRemote.verifyCode(any),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tVerifyEntity));

      final result = await repo.verifyCode("123456");

      expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
    });

    test("error", () async {
      when(mockRemote.verifyCode(any)).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception("error")),
      );

      final result = await repo.verifyCode("123456");

      expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
    });
  });

  // =========================
  // RESET PASSWORD
  // =========================
  group("resetPassword", () {
    test("success", () async {
      when(
        mockRemote.resetPassword(
          email: anyNamed("email"),
          newPassword: anyNamed("newPassword"),
        ),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tResetEntity));

      final result = await repo.resetPassword(
        email: "test@test.com",
        newPassword: "123456",
      );

      expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
    });

    test("error", () async {
      when(
        mockRemote.resetPassword(
          email: anyNamed("email"),
          newPassword: anyNamed("newPassword"),
        ),
      ).thenAnswer(
        (_) async => ErrorBaseResponse(exception: Exception("error")),
      );

      final result = await repo.resetPassword(
        email: "test@test.com",
        newPassword: "123456",
      );

      expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
    });
  });
}
