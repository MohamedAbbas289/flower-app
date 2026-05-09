import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/auth/signup/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/auth/signup/domain/usecases/signup_user_use_case.dart';
import 'package:flower_app/features/auth/signup/presentation/signup_view_model/signup_event.dart';
import 'package:flower_app/features/auth/signup/presentation/signup_view_model/signup_state.dart';
import 'package:flower_app/features/auth/signup/presentation/signup_view_model/signup_view_model.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'signup_view_model_test.mocks.dart';

@GenerateMocks([SignupUserUseCase])
void main() {
  late MockSignupUserUseCase mockSignupUserUseCase;
  late SignupViewModel viewModel;

  setUpAll(() {
    provideDummy<BaseResponse<AuthResponseEntity>>(
      SuccessBaseResponse<AuthResponseEntity>(data: const AuthResponseEntity()),
    );
  });

  setUp(() {
    mockSignupUserUseCase = MockSignupUserUseCase();
    viewModel = SignupViewModel(mockSignupUserUseCase);
  });

  group('SignupViewModel', () {
    test('initial state should be const SignupStates()', () {
      expect(viewModel.state, equals(const SignupState()));
    });
    final request = SignupRequestModel(
      firstName: "AbdElRahman",
      lastName: "Shalaan",
      email: "abdelrahman@gmail.com",
      password: "password",
      rePassword: "password",
      phone: "01000000000",
      gender: "male",
    );
    blocTest<SignupViewModel, SignupState>(
      'should emit loading then success when signup succeeds',

      build: () {
        final successResponse = SuccessBaseResponse<AuthResponseEntity>(
          data: const AuthResponseEntity(
            message: 'Signup successful',
            token: 'token_123',
          ),
        );

        when(
          mockSignupUserUseCase.execute(requestModel: request),
        ).thenAnswer((_) async => successResponse);

        return viewModel;
      },

      act: (cubit) {
        cubit.doEvent(SignupRequestEvent(requestModel: request));
      },

      expect: () => [
        SignupState(signupState: BaseState.loading()),

        SignupState(
          signupState: BaseState.success(
            const AuthResponseEntity(
              message: 'Signup successful',
              token: 'token_123',
            ),
          ),
        ),
      ],

      verify: (_) {
        verify(mockSignupUserUseCase.execute(requestModel: request)).called(1);
        verifyNoMoreInteractions(mockSignupUserUseCase);
      },
    );

    blocTest<SignupViewModel, SignupState>(
      'should emit loading then error when signup fails',

      build: () {
        final errorResponse = ErrorBaseResponse<AuthResponseEntity>(
          exception: Exception('network error'),
        );

        when(
          mockSignupUserUseCase.execute(requestModel: request),
        ).thenAnswer((_) async => errorResponse);

        return viewModel;
      },

      act: (cubit) {
        cubit.doEvent(SignupRequestEvent(requestModel: request));
      },

      expect: () => [
        SignupState(signupState: BaseState.loading()),
        SignupState(
          signupState: BaseState.error(
            'Something went wrong. Please try again later',
          ),
        ),
      ],
    );
  });
}
