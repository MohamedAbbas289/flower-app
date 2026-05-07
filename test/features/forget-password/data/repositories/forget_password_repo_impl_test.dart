import 'package:dio/dio.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/forget-password/api/data_source/forget_password_remote_data_source_impl.dart';
import 'package:flower_app/features/forget-password/data/repositories/forget_password_repo_impl.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'forget_password_repo_impl_test.mocks.dart';

@GenerateMocks([ForgetPasswordRemoteDataSourceImpl])
void main() {
  late ForgetPasswordRepoImpl repoImpl;
  late MockForgetPasswordRemoteDataSourceImpl mockRemote;

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
    mockRemote = MockForgetPasswordRemoteDataSourceImpl();
    repoImpl = ForgetPasswordRepoImpl(mockRemote);
  });

  // forgotPassword
  group("forgotPassword", () {
    group("Success Cases", () {
      test("returns SuccessBaseResponse with entity on success", () async {
        // Arrange
        when(mockRemote.forgotPassword(any)).thenAnswer((_) async => tEntity);

        // Act
        final result = await repoImpl.forgotPassword("test@example.com");

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as SuccessBaseResponse<ForgetPasswordEntity>).data,
          tEntity,
        );
        verify(mockRemote.forgotPassword("test@example.com")).called(1);
      });

      test("calls remote exactly once per invocation", () async {
        // Arrange
        when(mockRemote.forgotPassword(any)).thenAnswer((_) async => tEntity);

        // Act
        await repoImpl.forgotPassword("test@example.com");
        await repoImpl.forgotPassword("test@example.com");

        // Assert
        verify(mockRemote.forgotPassword("test@example.com")).called(2);
      });
    });

    group("Failure Cases", () {
      test("returns ErrorBaseResponse on DioException", () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: ""),
        );
        when(mockRemote.forgotPassword(any)).thenThrow(dioException);

        // Act
        final result = await repoImpl.forgotPassword("test@example.com");

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        // errorMessage يتعمل automatically من BaseError.handleException
        expect(
          (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
          isNotEmpty,
        );
      });

      test("returns ErrorBaseResponse on general Exception", () async {
        // Arrange
        when(
          mockRemote.forgotPassword(any),
        ).thenThrow(Exception("Unexpected error"));

        // Act
        final result = await repoImpl.forgotPassword("test@example.com");

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
          isNotEmpty,
        );
      });

      test("DioException 401 returns ErrorBaseResponse", () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: ""),
          response: Response(
            requestOptions: RequestOptions(path: ""),
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        );
        when(mockRemote.forgotPassword(any)).thenThrow(dioException);

        // Act
        final result = await repoImpl.forgotPassword("test@example.com");

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
      });

      test("DioException 500 returns ErrorBaseResponse", () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: ""),
          response: Response(
            requestOptions: RequestOptions(path: ""),
            statusCode: 500,
          ),
          type: DioExceptionType.badResponse,
        );
        when(mockRemote.forgotPassword(any)).thenThrow(dioException);

        // Act
        final result = await repoImpl.forgotPassword("test@example.com");

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
      });

      test(
        "connection timeout DioException returns ErrorBaseResponse",
        () async {
          // Arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: ""),
            type: DioExceptionType.connectionTimeout,
          );
          when(mockRemote.forgotPassword(any)).thenThrow(dioException);

          // Act
          final result = await repoImpl.forgotPassword("test@example.com");

          // Assert
          expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        },
      );
    });
  });

  // verifyCode
  group("verifyCode", () {
    group("Success Cases", () {
      test("returns SuccessBaseResponse with entity on success", () async {
        // Arrange
        when(mockRemote.verifyCode(any)).thenAnswer((_) async => tVerifyEntity);

        // Act
        final result = await repoImpl.verifyCode("123456");

        // Assert
        expect(result, isA<SuccessBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as SuccessBaseResponse<ForgetPasswordEntity>).data,
          tVerifyEntity,
        );
        verify(mockRemote.verifyCode("123456")).called(1);
      });
    });

    group("Failure Cases", () {
      test("returns ErrorBaseResponse on DioException", () async {
        // Arrange
        when(
          mockRemote.verifyCode(any),
        ).thenThrow(DioException(requestOptions: RequestOptions(path: "")));

        // Act
        final result = await repoImpl.verifyCode("123456");

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
          isNotEmpty,
        );
      });

      test("returns ErrorBaseResponse on general Exception", () async {
        // Arrange
        when(
          mockRemote.verifyCode(any),
        ).thenThrow(Exception("Unexpected error"));

        // Act
        final result = await repoImpl.verifyCode("123456");

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
          isNotEmpty,
        );
      });
    });
  });

  // resetPassword
  group("resetPassword", () {
    group("Success Cases", () {
      test("returns SuccessBaseResponse with entity on success", () async {
        // Arrange
        when(
          mockRemote.resetPassword(
            email: anyNamed("email"),
            newPassword: anyNamed("newPassword"),
          ),
        ).thenAnswer((_) async => tResetEntity);

        // Act
        final result = await repoImpl.resetPassword(
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
          mockRemote.resetPassword(
            email: "test@example.com",
            newPassword: "NewPass123!",
          ),
        ).called(1);
      });
    });

    group("Failure Cases", () {
      test("returns ErrorBaseResponse on DioException", () async {
        // Arrange
        when(
          mockRemote.resetPassword(
            email: anyNamed("email"),
            newPassword: anyNamed("newPassword"),
          ),
        ).thenThrow(DioException(requestOptions: RequestOptions(path: "")));

        // Act
        final result = await repoImpl.resetPassword(
          email: "test@example.com",
          newPassword: "NewPass123!",
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
          isNotEmpty,
        );
      });

      test("returns ErrorBaseResponse on general Exception", () async {
        // Arrange
        when(
          mockRemote.resetPassword(
            email: anyNamed("email"),
            newPassword: anyNamed("newPassword"),
          ),
        ).thenThrow(Exception("Unexpected error"));

        // Act
        final result = await repoImpl.resetPassword(
          email: "test@example.com",
          newPassword: "NewPass123!",
        );

        // Assert
        expect(result, isA<ErrorBaseResponse<ForgetPasswordEntity>>());
        expect(
          (result as ErrorBaseResponse<ForgetPasswordEntity>).errorMessage,
          isNotEmpty,
        );
      });
    });
  });
}
