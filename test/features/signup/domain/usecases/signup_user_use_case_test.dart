import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/auth/signup/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/auth/signup/domain/repositories_contract/signup_repository_contract.dart';
import 'package:flower_app/features/auth/signup/domain/usecases/signup_user_use_case.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'signup_user_use_case_test.mocks.dart';

@GenerateMocks([SignupRepositoryContract])
void main() {
  late MockSignupRepositoryContract mockSignupRepository;
  late SignupUserUseCase signupUserUseCase;

  setUpAll(() {
    provideDummy<BaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse<AuthResponseEntity>(data: const AuthResponseEntity()),
    );
  });

  setUp(() {
    mockSignupRepository = MockSignupRepositoryContract();
    signupUserUseCase = SignupUserUseCase(mockSignupRepository);
  });

  group('SignupUserUseCase', () {
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
      'should return SuccessBaseResponse<AuthResponseEntity> when repository succeeds',
      () async {
        final successResponse = SuccessBaseResponse<AuthResponseEntity>(
          data: const AuthResponseEntity(
            message: "Signup successful",
            token: "token_123",
          ),
        );

        when(
          mockSignupRepository.signup(requestModel: request),
        ).thenAnswer((_) async => successResponse);

        final result = await signupUserUseCase.execute(requestModel: request);

        expect(result, isA<SuccessBaseResponse<AuthResponseEntity>>());
        final success = result as SuccessBaseResponse<AuthResponseEntity>;
        expect(success.data, isA<AuthResponseEntity>());
        expect(success.data.message, "Signup successful");
        expect(success.data.token, "token_123");
        verify(mockSignupRepository.signup(requestModel: request)).called(1);
        verifyNoMoreInteractions(mockSignupRepository);
      },
    );

    test(
      'should return ErrorBaseResponse<AuthResponseEntity> when repository fails',
      () async {
        final exception = Exception("network error");
        final errorResponse = ErrorBaseResponse<AuthResponseEntity>(
          exception: exception,
        );

        when(
          mockSignupRepository.signup(requestModel: request),
        ).thenAnswer((_) async => errorResponse);

        final result = await signupUserUseCase.execute(requestModel: request);

        expect(result, isA<ErrorBaseResponse<AuthResponseEntity>>());
        final error = result as ErrorBaseResponse<AuthResponseEntity>;
        expect(error.exception, exception);
        verify(mockSignupRepository.signup(requestModel: request)).called(1);
        verifyNoMoreInteractions(mockSignupRepository);
      },
    );
  });
}
