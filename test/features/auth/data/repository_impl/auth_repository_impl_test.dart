import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/models/user_model.dart';
import 'package:flower_app/features/auth/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/auth/data/data_sources_contract/auth_remote_data_source_contract.dart';
import 'package:flower_app/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:flower_app/features/auth/domain/entities/forget_password_entity.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSourceContract, AuthManager])
void main() {
  late MockAuthRemoteDataSourceContract mockRemoteDataSource;
  late MockAuthManager mockAuthManager;
  late AuthRepositoryImpl repo;

  setUpAll(() {
    provideDummy<BaseResponse<AuthResponse>>(
      SuccessBaseResponse<AuthResponse>(data: AuthResponse()),
    );
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

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSourceContract();
    mockAuthManager = MockAuthManager();
    repo = AuthRepositoryImpl(mockRemoteDataSource, mockAuthManager);
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

    test(
      'should return SuccessBaseResponse<AuthResponseEntity> when datasource succeeds',
      () async {
        final user = User(
          firstName: request.firstName,
          lastName: request.lastName,
        );
        final authResponse = AuthResponse(
          message: "Signup successful",
          token: "token_123",
          user: user,
        );
        final successResponse = SuccessBaseResponse<AuthResponse>(
          data: authResponse,
        );
        when(
          mockRemoteDataSource.signup(requestModel: request),
        ).thenAnswer((_) async => successResponse);

        final result = await repo.signup(requestModel: request);
        expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
        final success = result as SuccessBaseResponse<AuthResponseEntity>;
        expect(success.data, isA<AuthResponseEntity>());
        expect(success.data.message, "Signup successful");
        expect(success.data.token, "token_123");
        expect(success.data.user, isNotNull);
        expect(success.data.user?.firstName, request.firstName);
        expect(success.data.user?.lastName, request.lastName);
        verify(mockRemoteDataSource.signup(requestModel: request)).called(1);
      },
    );

    test(
      'should return ErrorBaseResponse<AuthResponseEntity> when datasource fails',
      () async {
        final exception = Exception('Network error');
        final errorResponse = ErrorBaseResponse<AuthResponse>(
          exception: exception,
        );
        when(
          mockRemoteDataSource.signup(requestModel: request),
        ).thenAnswer((_) async => errorResponse);

        final result = await repo.signup(requestModel: request);
        expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
        final error = result as ErrorBaseResponse<AuthResponseEntity>;
        expect(error.exception, exception);
        verify(mockRemoteDataSource.signup(requestModel: request)).called(1);
      },
    );
  });

  // =========================
  // FORGOT PASSWORD
  // =========================
  group("forgotPassword", () {
    final tEntity = ForgetPasswordEntity(
      forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.forgotPassword,
      message: "Success",
      info: "Code sent to your email",
    );

    test("success", () async {
      when(
        mockRemoteDataSource.forgotPassword(any),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tEntity));

      final result = await repo.forgotPassword("test@test.com");

      expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());

      final success = result as SuccessBaseResponse<ForgetPasswordEntity>;
      expect(success.data, tEntity);
    });

    test("error", () async {
      when(mockRemoteDataSource.forgotPassword(any)).thenAnswer(
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
    final tVerifyEntity = ForgetPasswordEntity(
      forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.verifyCode,
      status: "Success",
      message: "Code verified successfully",
    );

    test("success", () async {
      when(
        mockRemoteDataSource.verifyCode(any),
      ).thenAnswer((_) async => SuccessBaseResponse(data: tVerifyEntity));

      final result = await repo.verifyCode("123456");

      expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
    });

    test("error", () async {
      when(mockRemoteDataSource.verifyCode(any)).thenAnswer(
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
    final tResetEntity = ForgetPasswordEntity(
      forgetPasswordRecoveryStep: ForgetPasswordRecoveryStep.resetPassword,
      status: "Success",
      message: "Password changed successfully",
    );

    test("success", () async {
      when(
        mockRemoteDataSource.resetPassword(
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
        mockRemoteDataSource.resetPassword(
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
