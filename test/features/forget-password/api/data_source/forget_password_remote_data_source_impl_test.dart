import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget-password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:test/test.dart';

void main() {
  late ForgetPasswordRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = ForgetPasswordRemoteDataSourceImpl();
  });

  // forgotPassword
  group("forgotPassword", () {
    test(
      "returns entity with forgotPassword step and success message",
      () async {
        // Act
        final result = await dataSource.forgotPassword("test@example.com");

        // Assert
        expect(result, isA<ForgetPasswordEntity>());
        expect(
          result.forgetPasswordRecoveryStep,
          ForgetPasswordRecoveryStep.forgotPassword,
        );
        expect(result.message, "Success");
        expect(result.info, "Code sent to your email");
      },
    );

    test("returns same result regardless of email value", () async {
      // Act
      final result1 = await dataSource.forgotPassword("a@a.com");
      final result2 = await dataSource.forgotPassword("b@b.com");

      // Assert
      expect(
        result1.forgetPasswordRecoveryStep,
        result2.forgetPasswordRecoveryStep,
      );
      expect(result1.message, result2.message);
    });
  });

  // verifyCode
  group("verifyCode", () {
    test("returns success entity when code is '123456'", () async {
      // Act
      final result = await dataSource.verifyCode("123456");

      // Assert
      expect(result, isA<ForgetPasswordEntity>());
      expect(
        result.forgetPasswordRecoveryStep,
        ForgetPasswordRecoveryStep.verifyCode,
      );
      expect(result.status, "Success");
      expect(result.message, "Code verified successfully");
    });

    test("returns error entity when code is wrong", () async {
      // Act
      final result = await dataSource.verifyCode("000000");

      // Assert
      expect(result, isA<ForgetPasswordEntity>());
      expect(
        result.forgetPasswordRecoveryStep,
        ForgetPasswordRecoveryStep.verifyCode,
      );
      expect(result.status, "Error");
      expect(result.message, "Invalid code");
    });

    test("returns error entity when code is empty string", () async {
      // Act
      final result = await dataSource.verifyCode("");

      // Assert
      expect(result.status, "Error");
      expect(result.message, "Invalid code");
    });

    test("returns error entity when code is almost correct", () async {
      // Act
      final result = await dataSource.verifyCode("12345");

      // Assert
      expect(result.status, "Error");
    });
  });

  // resetPassword
  group("resetPassword", () {
    test("returns success entity with resetPassword step", () async {
      // Act
      final result = await dataSource.resetPassword(
        email: "test@example.com",
        newPassword: "NewPass123!",
      );

      // Assert
      expect(result, isA<ForgetPasswordEntity>());
      expect(
        result.forgetPasswordRecoveryStep,
        ForgetPasswordRecoveryStep.resetPassword,
      );
      expect(result.status, "Success");
      expect(result.message, "Password changed successfully");
    });

    test(
      "returns same result regardless of email or password values",
      () async {
        // Act
        final result1 = await dataSource.resetPassword(
          email: "a@a.com",
          newPassword: "pass1",
        );
        final result2 = await dataSource.resetPassword(
          email: "b@b.com",
          newPassword: "pass2",
        );

        // Assert
        expect(result1.status, result2.status);
        expect(result1.message, result2.message);
        expect(
          result1.forgetPasswordRecoveryStep,
          result2.forgetPasswordRecoveryStep,
        );
      },
    );
  });
}
