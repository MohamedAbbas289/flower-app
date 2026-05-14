import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/entities/user_entity.dart';
import 'package:flower_app/features/auth/login/api/request_models/login_request_model.dart';
import 'package:flower_app/features/auth/login/domain/use_cases/login_use_case.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_events.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_state.dart';
import 'package:flower_app/features/auth/login/presentation/view_model/login_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}


void main() {
  late MockLoginUseCase loginUseCase;

  setUpAll(() {
    registerFallbackValue(
      LoginRequestModel(email: '', password: '', rememberMe: false),
    );
  });

  setUp(() {
    loginUseCase = MockLoginUseCase();
  });

  LoginViewModel buildViewModel() =>
      LoginViewModel(loginUseCase);

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


  group('LoginViewModel', () {
    test('initial state is LoginStates with default BaseState', () {
      expect(buildViewModel().state, const LoginState());
    });


    blocTest<LoginViewModel, LoginState>(
      'emits loading then success state on valid credentials',
      build: buildViewModel,
      setUp: () {

        when(
              () =>
              loginUseCase.execute(requestModel: any(named: 'requestModel')),
        ).thenAnswer((_) async => SuccessBaseResponse(data: validEntity));
      },
      act: (vm) => vm.doEvent(loginEvent()),
      expect: () =>
      [
        isA<LoginState>()
            .having((s) => s.loginState.isLoading, 'isLoading', true),
        isA<LoginState>()
            .having((s) => s.loginState.data, 'data', validEntity),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits loading then error state when API fails',
      build: buildViewModel,
      setUp: () {
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
        isA<LoginState>()
            .having((s) => s.loginState.isLoading, 'isLoading', true),
        isA<LoginState>()
            .having((s) => s.loginState.msg, 'msg', isNotNull),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'passes rememberMe=true to LoginUseCase',
      build: buildViewModel,
      setUp: () {
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
