import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/entities/user_entity.dart';
import 'package:flower_app/features/login/api/request_models/login_request_model.dart';
import 'package:flower_app/features/login/domain/use_cases/login_use_case.dart';
import 'package:flower_app/features/login/domain/use_cases/validate_login_inputs_use_case.dart';
import 'package:flower_app/features/login/presentation/view_model/login_events.dart';
import 'package:flower_app/features/login/presentation/view_model/login_state.dart';
import 'package:flower_app/features/login/presentation/view_model/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockValidateLoginInputsUseCase extends Mock
    implements ValidateLoginInputsUseCase {}

void main() {
  late MockLoginUseCase loginUseCase;
  late MockValidateLoginInputsUseCase validateUseCase;

  setUpAll(() {
    registerFallbackValue(
      LoginRequestModel(email: '', password: '', rememberMe: false),
    );
  });

  setUp(() {
    loginUseCase = MockLoginUseCase();
    validateUseCase = MockValidateLoginInputsUseCase();
  });

  LoginViewModel buildViewModel() =>
      LoginViewModel(loginUseCase, validateUseCase);

  const validEmail = 'user@example.com';
  const validPassword = 'secret123';

  final validEntity = AuthResponseEntity(
    token: 'test-token',
    message: 'ok',
    user: const UserEntity(id: 'uid-1'),
  );


  LoginRequestEvent loginEvent({bool rememberMe = false}) =>
      LoginRequestEvent(
        requestModel: LoginRequestModel(
          email: validEmail,
          password: validPassword,
          rememberMe: rememberMe,
        ),
      );

  void stubValidValidation() {
    when(
      () => validateUseCase(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenReturn(const LoginValidationResult());
  }

  void stubInvalidValidation({String? emailError, String? passwordError}) {
    when(
      () => validateUseCase(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenReturn(
      LoginValidationResult(
        emailError: emailError,
        passwordError: passwordError,
      ),
    );
  }

  group('LoginViewModel', () {
    test('initial state is LoginStates with default BaseState', () {
      expect(buildViewModel().state, const LoginStates());
    });

    blocTest<LoginViewModel, LoginStates>(
      'emits validation emailError when email is invalid',
      build: buildViewModel,
      setUp: () =>
          stubInvalidValidation(emailError: 'This Email is not valid'),
      act: (vm) => vm.doEvent(loginEvent()),
      expect: () => [
        isA<LoginStates>().having(
              (s) => s.emailError,
          'emailError',
          'This Email is not valid',
        ),
      ],
    );

    blocTest<LoginViewModel, LoginStates>(
      'emits validation passwordError when password is empty',
      build: buildViewModel,
      setUp: () => stubInvalidValidation(passwordError: 'Invalid password'),
      act: (vm) => vm.doEvent(loginEvent()),
      expect: () => [
        isA<LoginStates>().having(
              (s) => s.passwordError,
          'passwordError',
          'Invalid password',
        ),
      ],
    );

    blocTest<LoginViewModel, LoginStates>(
      'emits loading then success state on valid credentials',
      build: buildViewModel,
      setUp: () {
        stubValidValidation();
        when(
              () =>
              loginUseCase.execute(requestModel: any(named: 'requestModel')),
        ).thenAnswer((_) async => SuccessBaseResponse(data: validEntity));
      },
      act: (vm) => vm.doEvent(loginEvent()),
      expect: () =>
      [
        isA<LoginStates>()
            .having((s) => s.loginState.isLoading, 'isLoading', true),
        isA<LoginStates>()
            .having((s) => s.loginState.data, 'data', validEntity),
      ],
    );

    blocTest<LoginViewModel, LoginStates>(
      'emits loading then error state when API fails',
      build: buildViewModel,
      setUp: () {
        stubValidValidation();
        when(
              () =>
              loginUseCase.execute(requestModel: any(named: 'requestModel')),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('Unauthorized')),
        );
      },
      act: (vm) => vm.doEvent(loginEvent()),
      expect: () =>
      [
        isA<LoginStates>()
            .having((s) => s.loginState.isLoading, 'isLoading', true),
        isA<LoginStates>()
            .having((s) => s.loginState.msg, 'msg', isNotNull),
      ],
    );

    blocTest<LoginViewModel, LoginStates>(
      'passes rememberMe=true to LoginUseCase',
      build: buildViewModel,
      setUp: () {
        stubValidValidation();
        when(
              () =>
              loginUseCase.execute(requestModel: any(named: 'requestModel')),
        ).thenAnswer((_) async => SuccessBaseResponse(data: validEntity));
      },
      act: (vm) => vm.doEvent(loginEvent(rememberMe: true)),
      verify: (_) {
        verify(
              () =>
              loginUseCase.execute(
                requestModel: any(named: 'requestModel'),
          ),
        ).called(1);
      },
    );
  });
}
