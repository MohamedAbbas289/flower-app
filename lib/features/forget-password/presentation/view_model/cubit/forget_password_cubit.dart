import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget-password/domain/usecase/forget_password_use_case.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/events/forget_password_events.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/states/forget_password_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase forgetPasswordUseCase;

  ForgetPasswordCubit(this.forgetPasswordUseCase)
    : super(const ForgetPasswordState());

  void onEvent(ForgetPasswordEvent event) {
    if (event is ForgotPasswordEvent) {
      _forgotPassword(event.email);
    } else if (event is VerifyCodeEvent) {
      _verifyCode(event.code);
    } else if (event is ResetPasswordEvent) {
      _resetPassword(event.email, event.password);
    }
  }

  Future<void> _forgotPassword(String email) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await forgetPasswordUseCase.forgotPassword(email);

    if (result is SuccessBaseResponse<ForgetPasswordEntity>) {
      emit(state.copyWith(isLoading: false, data: result.data));
    } else if (result is ErrorBaseResponse<ForgetPasswordEntity>) {
      emit(state.copyWith(isLoading: false, error: result.errorMessage));
    }
  }

  Future<void> _verifyCode(String code) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await forgetPasswordUseCase.verifyCode(code);

    if (result is SuccessBaseResponse<ForgetPasswordEntity>) {
      emit(state.copyWith(isLoading: false, data: result.data));
    } else if (result is ErrorBaseResponse<ForgetPasswordEntity>) {
      emit(state.copyWith(isLoading: false, error: result.errorMessage));
    }
  }

  Future<void> _resetPassword(String email, String pass) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await forgetPasswordUseCase.resetPassword(
      email: email,
      newPassword: pass,
    );

    if (result is SuccessBaseResponse<ForgetPasswordEntity>) {
      emit(state.copyWith(isLoading: false, data: result.data));
    } else if (result is ErrorBaseResponse<ForgetPasswordEntity>) {
      emit(state.copyWith(isLoading: false, error: result.errorMessage));
    }
  }
}
