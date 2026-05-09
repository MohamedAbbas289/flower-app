import 'package:test/test.dart';

import 'package:flower_app/features/forget-password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/config/base_response/base_response.dart';

void main() {
  late ForgetPasswordRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = ForgetPasswordRemoteDataSourceImpl();
  });

  group("forgotPassword", () {
    test("should return forgotPassword success", () async {
      final result = await dataSource.forgotPassword("test@example.com");

      expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());

      final success = result as SuccessBaseResponse<ForgetPasswordEntity>;

      expect(
        success.data.forgetPasswordRecoveryStep,
        ForgetPasswordRecoveryStep.forgotPassword,
      );
    });
  });

  group("verifyCode", () {
    test("valid code returns success", () async {
      final result = await dataSource.verifyCode("123456");

      expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());

      final success = result as SuccessBaseResponse<ForgetPasswordEntity>;

      expect(
        success.data.forgetPasswordRecoveryStep,
        ForgetPasswordRecoveryStep.verifyCode,
      );
      expect(success.data.status, "Success");
    });

    test("invalid code returns error", () async {
      final result = await dataSource.verifyCode("000000");

      expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());

      final error = result as ErrorBaseResponse<ForgetPasswordEntity>;

      expect(error.exception.toString(), contains("Invalid code"));
    });
  });

  group("resetPassword", () {
    test("returns reset success", () async {
      final result = await dataSource.resetPassword(
        email: "test@test.com",
        newPassword: "123456",
      );

      expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());

      final success = result as SuccessBaseResponse<ForgetPasswordEntity>;

      expect(
        success.data.forgetPasswordRecoveryStep,
        ForgetPasswordRecoveryStep.resetPassword,
      );
    });
  });
}
