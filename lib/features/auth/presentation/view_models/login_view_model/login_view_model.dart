import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../api/request_models/login_request_model.dart';
import '../../domain/use_cases/login_use_case.dart';
import 'login_events.dart';
import 'login_state.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._loginUseCase) : super(const LoginState());
  final LoginUseCase _loginUseCase;

  void doEvent(LoginEvents event) {
    switch (event) {
      case LoginRequestEvent():
        _loginUser(requestModel: event.requestModel);
        break;
    }
  }

  Future<void> _loginUser({required LoginRequestModel requestModel}) async {
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
