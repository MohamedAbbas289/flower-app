import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/login/api/request_models/login_request_model.dart';
import 'package:flower_app/features/login/domain/use_cases/login_use_case.dart';
import 'package:flower_app/features/login/domain/use_cases/validate_login_inputs_use_case.dart';
import 'package:flower_app/features/login/presentation/view_model/login_events.dart';
import 'package:flower_app/features/login/presentation/view_model/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginViewModel extends Cubit<LoginStates> {
  LoginViewModel(this._loginUseCase, this._validateLoginInputsUseCase)
    : super(const LoginStates());
  final LoginUseCase _loginUseCase;
  final ValidateLoginInputsUseCase _validateLoginInputsUseCase;

  void doEvent(LoginEvents event) {
    switch (event) {
      case LoginRequestEvent():
        _loginUser(requestModel: event.requestModel);
        break;
    }
  }

  Future<void> _loginUser({required LoginRequestModel requestModel}) async {
    final validationResult = _validateLoginInputsUseCase(
      email: requestModel.email,
      password: requestModel.password,
    );

    if (!validationResult.isValid) {
      emit(
        state.copyWith(
          emailError: validationResult.emailError,
          passwordError: validationResult.passwordError,
        ),
      );
      return;
    }

    emit(state.copyWith(loginState: BaseState.loading()));
    final response = await _loginUseCase.execute(requestModel: requestModel);
    switch (response) {
      case SuccessBaseResponse<AuthResponseEntity>():
        emit(state.copyWith(loginState: BaseState.success(response.data)));
        break;
      case ErrorBaseResponse<AuthResponseEntity>():
        emit(
          state.copyWith(loginState: BaseState.error(response.errorMessage)),
        );
        break;
    }
  }
}
