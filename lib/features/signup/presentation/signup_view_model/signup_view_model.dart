import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/signup/api/request_models/signup_request_model.dart';
import 'package:flower_app/features/signup/domain/usecases/signup_user_use_case.dart';
import 'package:flower_app/features/signup/presentation/signup_view_model/signup_events.dart';
import 'package:flower_app/features/signup/presentation/signup_view_model/signup_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignupViewModel extends Cubit<SignupStates> {
  SignupViewModel(this._signupUserUseCase) : super(const SignupStates());

  final SignupUserUseCase _signupUserUseCase;

  void doEvent(SignupEvents event) {
    switch (event) {
      case SignupRequestEvent():
        _signupUser(requestModel: event.requestModel);
        break;
    }
  }

  Future<void> _signupUser({required SignupRequestModel requestModel}) async {
    emit(
      state.copyWith(
        signupState: state.signupState.copyWith(
          isLoading: true,
          data: null,
          msg: null,
        ),
      ),
    );
    final response = await _signupUserUseCase.execute(
      requestModel: requestModel,
    );

    switch (response) {
      case SuccessBaseResponse<AuthResponseEntity>():
        emit(
          state.copyWith(
            signupState: state.signupState.copyWith(
              isLoading: false,
              data: response.data,
              msg: null,
            ),
          ),
        );
        break;
      case ErrorBaseResponse<AuthResponseEntity>():
        emit(
          state.copyWith(
            signupState: state.signupState.copyWith(
              isLoading: false,
              data: null,
              msg: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
