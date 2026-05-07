import 'package:equatable/equatable.dart';
import 'package:flower_app/features/forget-password/domain/entities/forget_password_entity.dart';

class ForgetPasswordState extends Equatable {
  final bool isLoading;
  final ForgetPasswordEntity? data;
  final String? error;

  const ForgetPasswordState({this.isLoading = false, this.data, this.error});

  ForgetPasswordState copyWith({
    bool? isLoading,
    ForgetPasswordEntity? data,
    String? error,
    bool clearError = false,
    bool clearData = false,
  }) {
    return ForgetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      data: clearData ? null : (data ?? this.data),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [isLoading, data, error];
}
