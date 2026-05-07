import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';
import 'package:flower_app/features/forget-password/domain/usecase/forget_password_use_case.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/events/forget_password_events.dart';
import 'package:flower_app/features/forget-password/presentation/view_model/states/forget_password_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase useCase;

  ForgetPasswordCubit(this.useCase) : super(const ForgetPasswordState());

  void onEvent(ForgetPasswordEvent event) {
    if (event is ForgotPasswordEvent) {
      _forgot(event.email);
    } else if (event is VerifyCodeEvent) {
      _verify(event.code);
    } else if (event is ResetPasswordEvent) {
      _reset(event.email, event.password);
    }
  }

  Future<void> _handleRequest<T>(
    Future<BaseResponse<T>> Function() request,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await request();

    if (result is SuccessBaseResponse<T>) {
      emit(state.copyWith(isLoading: false, data: result.data as ForgetPasswordEntity));
    } else if (result is ErrorBaseResponse<T>) {
      emit(state.copyWith(isLoading: false, error: result.errorMessage));
    }
  }

  Future<void> _forgot(String email) async {
    await _handleRequest<ForgetPasswordEntity>(
      () => useCase.forgotPassword(email),
    );
  }

  Future<void> _verify(String code) async {
    await _handleRequest<ForgetPasswordEntity>(() => useCase.verifyCode(code));
  }

  Future<void> _reset(String email, String pass) async {
    await _handleRequest<ForgetPasswordEntity>(
      () => useCase.resetPassword(email: email, newPassword: pass),
    );
  }
}
