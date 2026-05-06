import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';

class ForgetPasswordState {
  final bool isLoading;
  final ForgetPasswordEntity? data;
  final String? error;

  const ForgetPasswordState({this.isLoading = false, this.data, this.error});

  ForgetPasswordState copyWith({
    bool? isLoading,
    ForgetPasswordEntity? data,
    String? error,
  }) {
    return ForgetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}
