import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/auth/api/api_client/auth_api_client.dart';
import 'package:flower_app/features/auth/api/data_sources_impl/auth_remote_data_source_impl.dart';
import 'package:flower_app/features/auth/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/auth/domain/entities/forget_password_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'auth_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthApiClient])
void main() {
  late MockAuthApiClient mockAuthApiClient;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockAuthApiClient = MockAuthApiClient();
    dataSource = AuthRemoteDataSourceImpl(mockAuthApiClient);
  });

  group('signup', () {
    final request = SignupRequestModel(
      firstName: "AbdElRahman",
      lastName: "Shalaan",
      email: "abdelrahman@gmail.com",
      password: "password",
      rePassword: "password",
      phone: "01000000000",
      gender: "male",
    );

    test('should return SuccessBaseResponse when api call succeeds', () async {
      final response = AuthResponse(message: "Signup successful");

      when(
        mockAuthApiClient.signup(requestModel: request),
      ).thenAnswer((_) async => response);

      final result = await dataSource.signup(requestModel: request);

      expect(result, isA<SuccessBaseResponse<AuthResponse>>());
      expect((result as SuccessBaseResponse<AuthResponse>).data, response);
      verify(mockAuthApiClient.signup(requestModel: request)).called(1);
    });

    test('should return ErrorBaseResponse when api throws exception', () async {
      final exception = Exception('network error');

      when(
        mockAuthApiClient.signup(requestModel: request),
      ).thenThrow(exception);

      final result = await dataSource.signup(requestModel: request);

      expect(result, isA<ErrorBaseResponse<AuthResponse>>());
      expect((result as ErrorBaseResponse).exception, exception);
      verify(mockAuthApiClient.signup(requestModel: request)).called(1);
    });
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
      final result = await dataSource.verifyCode("1234");

      expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());

      final success = result as SuccessBaseResponse<ForgetPasswordEntity>;

      expect(
        success.data.forgetPasswordRecoveryStep,
        ForgetPasswordRecoveryStep.verifyCode,
      );
      expect(success.data.status, "Success");
    });

    test("invalid code returns error", () async {
      final result = await dataSource.verifyCode("0000");

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
