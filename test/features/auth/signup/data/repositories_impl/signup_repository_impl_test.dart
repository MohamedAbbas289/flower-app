import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/core/models/user_model.dart';
import 'package:flower_app/features/auth/signup/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/auth/signup/data/datasources_contract/signup_remote_datasource_contract.dart';
import 'package:flower_app/features/auth/signup/data/repositories_impl/signup_repository_impl.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'signup_repository_impl_test.mocks.dart';


@GenerateMocks([SignupRemoteDatasourceContract])
void main() {
  late MockSignupRemoteDatasourceContract mockSignupRemoteDatasourceContract;
  late SignupRepositoryImpl signupRepositoryImpl;
  setUpAll(() {
    provideDummy<BaseResponse<AuthResponse>>(
      SuccessBaseResponse<AuthResponse>(data: AuthResponse()),
    );
  });
  setUp(() {
    mockSignupRemoteDatasourceContract = MockSignupRemoteDatasourceContract();
    signupRepositoryImpl = SignupRepositoryImpl(
      mockSignupRemoteDatasourceContract,
    );
  });

  group('SignupRepositoryImpl', () {
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
          mockSignupRemoteDatasourceContract.signup(requestModel: request),
        ).thenAnswer((_) async => successResponse);

        final result = await signupRepositoryImpl.signup(requestModel: request);
        expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
        final success = result as SuccessBaseResponse<AuthResponseEntity>;
        expect(success.data, isA<AuthResponseEntity>());
        expect(success.data.message, "Signup successful");
        expect(success.data.token, "token_123");
        expect(success.data.user, isNotNull);
        expect(success.data.user?.firstName, request.firstName);
        expect(success.data.user?.lastName, request.lastName);
        verify(
          mockSignupRemoteDatasourceContract.signup(requestModel: request),
        ).called(1);
        verifyNoMoreInteractions(mockSignupRemoteDatasourceContract);
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
          mockSignupRemoteDatasourceContract.signup(requestModel: request),
        ).thenAnswer((_) async => errorResponse);

        final result = await signupRepositoryImpl.signup(requestModel: request);
        expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
        final error = result as ErrorBaseResponse<AuthResponseEntity>;
        expect(error.exception, exception);
        verify(
          mockSignupRemoteDatasourceContract.signup(requestModel: request),
        ).called(1);
        verifyNoMoreInteractions(mockSignupRemoteDatasourceContract);
      },
    );
  });
}
