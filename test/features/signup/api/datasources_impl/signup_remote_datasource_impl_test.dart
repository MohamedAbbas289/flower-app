import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/models/auth_response.dart';
import 'package:flower_app/features/auth/signup/api/api_client/signup_api_client.dart';
import 'package:flower_app/features/auth/signup/api/datasources_impl/signup_remote_datasource_impl.dart';
import 'package:flower_app/features/auth/signup/api/request_models/signup_request_model.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'signup_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([SignupApiClient])
void main() {
  late MockSignupApiClient mockSignupApiClient;
  late SignupRemoteDatasourceImpl signupRemoteDatasourceImpl;

  setUp(() {
    mockSignupApiClient = MockSignupApiClient();
    signupRemoteDatasourceImpl = SignupRemoteDatasourceImpl(
      mockSignupApiClient,
    );
  });

  group('SignupRemoteDatasourceImpl', () {
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
        mockSignupApiClient.signup(requestModel: request),
      ).thenAnswer((_) async => response);

      final result = await signupRemoteDatasourceImpl.signup(
        requestModel: request,
      );

      expect(result, isA<SuccessBaseResponse<AuthResponse>>());
      expect((result as SuccessBaseResponse<AuthResponse>).data, response);
      verify(mockSignupApiClient.signup(requestModel: request)).called(1);
    });

    test('should return ErrorBaseResponse when api throws exception', () async {
      final exception = Exception('network error');

      when(
        mockSignupApiClient.signup(requestModel: request),
      ).thenThrow(exception);

      final result = await signupRemoteDatasourceImpl.signup(
        requestModel: request,
      );

      expect(result, isA<ErrorBaseResponse<AuthResponse>>());
      expect((result as ErrorBaseResponse).exception, exception);
      verify(mockSignupApiClient.signup(requestModel: request)).called(1);
    });
  });
}
