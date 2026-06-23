import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/use_cases/logout_use_case.dart';
import 'logout_events.dart';
import 'logout_state.dart';

@injectable
class LogoutViewModel extends Cubit<LogoutState> {
  LogoutViewModel(this._logoutUseCase) : super(const LogoutState());
  final LogoutUseCase _logoutUseCase;

  void doEvent(LogoutEvents event) {
    switch (event) {
      case LogoutRequestEvent():
        _logoutUser();
        break;
    }
  }

  Future<void> _logoutUser() async {
    emit(state.copyWith(logoutState: BaseState.loading()));
    final response = await _logoutUseCase.execute();
    switch (response) {
      case SuccessBaseResponse<void>():
        emit(state.copyWith(logoutState: BaseState.success(null)));
        break;
      case ErrorBaseResponse<void>():
        emit(
          state.copyWith(logoutState: BaseState.error(response.errorMessage)),
        );
        break;
    }
  }
}
