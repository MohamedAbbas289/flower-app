import 'package:flower_app/config/auth/auth_manager.dart';
import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flower_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:flower_app/features/profile/presentation/view_models/change_password_view_model/change_password_events.dart';
import 'package:flower_app/features/profile/presentation/view_models/change_password_view_model/change_password_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangePasswordViewModel extends Cubit<ChangePasswordState> {
  ChangePasswordViewModel(this._changePasswordUseCase, this._authManager)
    : super(const ChangePasswordState());

  final ChangePasswordUseCase _changePasswordUseCase;
  final AuthManager _authManager;

  void doEvent(ChangePasswordEvent event) {
    switch (event) {
      case ChangePasswordRequestEvent():
        _changePassword(
          password: event.password,
          newPassword: event.newPassword,
        );
        break;
      case EnableAutoValidateEvent():
        emit(state.copyWith(autoValidate: true));
        break;
    }
  }

  Future<void> _changePassword({
    required String password,
    required String newPassword,
  }) async {
    emit(state.copyWith(changePasswordState: BaseState.loading()));

    final response = await _changePasswordUseCase.changePassword(
      password: password,
      newPassword: newPassword,
    );

    switch (response) {
      case SuccessBaseResponse<ChangePasswordEntity>():
        final rememberMe = await _authManager.shouldAutoLogin();
        await _authManager.setAuthData(
          token: response.data.token,
          rememberMe: rememberMe,
        );
        emit(
          state.copyWith(changePasswordState: BaseState.success(response.data)),
        );
        break;
      case ErrorBaseResponse<ChangePasswordEntity>():
        emit(
          state.copyWith(
            changePasswordState: BaseState.error(response.errorMessage),
          ),
        );
        break;
    }
  }
}
