import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/core/entities/user_entity.dart';
import 'package:flower_app/features/login/domain/use_cases/login_use_case.dart';
import 'package:flower_app/features/login/domain/use_cases/remember_me_use_case.dart';
import 'package:flower_app/features/login/domain/use_cases/validate_login_inputs_use_case.dart';
import 'package:flower_app/features/login/presentation/view_model/login_cubit.dart';
import 'package:flower_app/features/login/presentation/view_model/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRememberMeUseCase extends Mock implements RememberMeUseCase {}

class MockValidateLoginInputsUseCase extends Mock
    implements ValidateLoginInputsUseCase {}

void main() {
  late MockLoginUseCase loginUseCase;
  late MockRememberMeUseCase rememberMeUseCase;
  late MockValidateLoginInputsUseCase validateUseCase;

  setUp(() {
    loginUseCase = MockLoginUseCase();
    rememberMeUseCase = MockRememberMeUseCase();
    validateUseCase = MockValidateLoginInputsUseCase();
  });

  LoginCubit buildCubit() =>
      LoginCubit(loginUseCase, rememberMeUseCase, validateUseCase);

  const validEmail = 'user@example.com';
  const validPassword = 'secret123';

  final validEntity = AuthResponseEntity(
    token: 'test-token',
    message: 'ok',
    user: const UserEntity(id: 'uid-1'),
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

  group('LoginCubit', () {
    test('initial state is LoginInitial', () {
      expect(buildCubit().state, const LoginInitial());
    });

    blocTest<LoginCubit, LoginState>(
      'emits LoginValidationError when email is invalid',
      build: buildCubit,
      setUp: () => stubInvalidValidation(emailError: 'This Email is not valid'),
      act: (cubit) =>
          cubit.login(email: 'bad', password: 'pass', rememberMe: false),
      expect: () => [
        const LoginValidationError(emailError: 'This Email is not valid'),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits LoginValidationError when password is empty',
      build: buildCubit,
      setUp: () => stubInvalidValidation(passwordError: 'Invalid password'),
      act: (cubit) =>
          cubit.login(email: validEmail, password: '', rememberMe: false),
      expect: () => [
        const LoginValidationError(passwordError: 'Invalid password'),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginSuccess] on valid credentials',
      build: buildCubit,
      setUp: () {
        stubValidValidation();
        when(
          () => loginUseCase(email: validEmail, password: validPassword),
        ).thenAnswer((_) async => SuccessBaseResponse(data: validEntity));
        when(
          () => rememberMeUseCase(
            authResponseEntity: validEntity,
            rememberMe: false,
          ),
        ).thenAnswer((_) async {});
      },
      act: (cubit) => cubit.login(
        email: validEmail,
        password: validPassword,
        rememberMe: false,
      ),
      expect: () => [const LoginLoading(), const LoginSuccess()],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginError] when API returns error',
      build: buildCubit,
      setUp: () {
        stubValidValidation();
        when(
          () => loginUseCase(email: validEmail, password: validPassword),
        ).thenAnswer(
          (_) async => ErrorBaseResponse(exception: Exception('Unauthorized')),
        );
      },
      act: (cubit) => cubit.login(
        email: validEmail,
        password: validPassword,
        rememberMe: false,
      ),
      expect: () => [const LoginLoading(), isA<LoginError>()],
    );

    blocTest<LoginCubit, LoginState>(
      'calls RememberMeUseCase with rememberMe=true on success',
      build: buildCubit,
      setUp: () {
        stubValidValidation();
        when(
          () => loginUseCase(email: validEmail, password: validPassword),
        ).thenAnswer((_) async => SuccessBaseResponse(data: validEntity));
        when(
          () => rememberMeUseCase(
            authResponseEntity: validEntity,
            rememberMe: true,
          ),
        ).thenAnswer((_) async {});
      },
      act: (cubit) => cubit.login(
        email: validEmail,
        password: validPassword,
        rememberMe: true,
      ),
      verify: (_) {
        verify(
          () => rememberMeUseCase(
            authResponseEntity: validEntity,
            rememberMe: true,
          ),
        ).called(1);
      },
    );
  });
}
