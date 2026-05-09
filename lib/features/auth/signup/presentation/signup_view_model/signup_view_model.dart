import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/auth/signup/presentation/signup_view_model/signup_event.dart';
import 'package:flower_app/features/auth/signup/presentation/signup_view_model/signup_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../api/request_models/signup_request_model.dart';
import '../../domain/usecases/signup_user_use_case.dart';

@injectable
class SignupViewModel extends Cubit<SignupState> {
  SignupViewModel(this._signupUserUseCase) : super(const SignupState());
  final SignupUserUseCase _signupUserUseCase;
  void doEvent(SignupEvent event) {
    switch (event) {
      case SignupRequestEvent():
        _signupUser(requestModel: event.requestModel);
        break;
      case EnableAutoValidateEvent():
        emit(state.copyWith(autoValidate: true));
        break;
    }
  }

  Future<void> _signupUser({required SignupRequestModel requestModel}) async {
    emit(state.copyWith(signupState: BaseState.loading()));
    final response = await _signupUserUseCase.execute(
      requestModel: requestModel,
    );
    switch (response) {
      case SuccessBaseResponse<AuthResponseEntity>():
        emit(state.copyWith(signupState: BaseState.success(response.data)));
        break;
      case ErrorBaseResponse<AuthResponseEntity>():
        emit(
          state.copyWith(signupState: BaseState.error(response.errorMessage)),
        );
        break;
    }
  }
}
