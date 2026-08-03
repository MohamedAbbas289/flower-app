import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base_state/base_state.dart';

class TrackOrderState extends Equatable {
  final String status;
  final String driverName;
  final String driverPhone;
  final bool userConfirmed;
  final int stepsCompleted;
  final bool isLoading;
  final String? error;
  final BaseState<void> confirmDeliveryState;

  const TrackOrderState({
    this.status = '',
    this.driverName = '',
    this.driverPhone = '',
    this.userConfirmed = false,
    this.stepsCompleted = 0,
    this.isLoading = false,
    this.error,
    this.confirmDeliveryState = const BaseState(),
  });

  TrackOrderState copyWith({
    String? status,
    String? driverName,
    String? driverPhone,
    bool? userConfirmed,
    int? stepsCompleted,
    bool? isLoading,
    String? error,
    BaseState<void>? cancelOrderState,
    BaseState<void>? confirmDeliveryState,
  }) {
    return TrackOrderState(
      status: status ?? this.status,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      userConfirmed: userConfirmed ?? this.userConfirmed,
      stepsCompleted: stepsCompleted ?? this.stepsCompleted,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      confirmDeliveryState: confirmDeliveryState ?? this.confirmDeliveryState,
    );
  }

  bool get showConfirmButton =>
      (status == 'arrived_user' || status == 'delivered') && !userConfirmed;

  @override
  List<Object?> get props => [
        status,
        driverName,
        driverPhone,
        userConfirmed,
        stepsCompleted,
        isLoading,
        error,
        confirmDeliveryState,
      ];
}
