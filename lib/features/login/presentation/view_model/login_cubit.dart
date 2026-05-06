import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/login/domain/use_cases/login_use_case.dart';
import 'package:flower_app/features/login/domain/use_cases/remember_me_use_case.dart';
import 'package:flower_app/features/login/domain/use_cases/validate_login_inputs_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final RememberMeUseCase _rememberMeUseCase;
  final ValidateLoginInputsUseCase _validateLoginInputsUseCase;

  LoginCubit(
    this._loginUseCase,
    this._rememberMeUseCase,
    this._validateLoginInputsUseCase,
  ) : super(const LoginInitial());

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final validationResult = _validateLoginInputsUseCase(
      email: email,
      password: password,
    );

    if (!validationResult.isValid) {
      emit(
        LoginValidationError(
          emailError: validationResult.emailError,
          passwordError: validationResult.passwordError,
        ),
      );
      return;
    }

    emit(const LoginLoading());

    final result = await _loginUseCase(email: email, password: password);

    switch (result) {
      case SuccessBaseResponse(data: final loginEntity):
        await _rememberMeUseCase(
          loginEntity: loginEntity,
          rememberMe: rememberMe,
        );
        emit(const LoginSuccess());
      case ErrorBaseResponse(errorMessage: final message):
        emit(LoginError(message));
    }
  }
}
