import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/core/values/firestore_keys.dart';
import 'package:flower_app/core/values/order_status.dart';
import 'package:flower_app/features/shopping/domain/use_cases/confirm_delivery_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'track_order_event.dart';
import 'track_order_state.dart';

@injectable
class TrackOrderViewModel extends Bloc<TrackOrderEvent, TrackOrderState> {
  final FirestoreService _firestoreService;
  final ConfirmDeliveryUseCase _confirmDeliveryUseCase;
  StreamSubscription<DocumentSnapshot>? _orderSubscription;

  TrackOrderViewModel(this._firestoreService, this._confirmDeliveryUseCase)
      : super(const TrackOrderState(isLoading: true)) {
    on<StartListeningEvent>(_onStartListening);
    on<OrderUpdatedEvent>(_onOrderUpdated);
    on<ConfirmDeliveryEvent>(_onConfirmDelivery);
  }

  void _onStartListening(
    StartListeningEvent event,
    Emitter<TrackOrderState> emit,
  ) {
    _orderSubscription?.cancel();
    _orderSubscription = _firestoreService
        .orderStream(event.orderId)
        .listen(
          (snapshot) {
            if (isClosed) return;
            if (!snapshot.exists) {
              add(
                const OrderUpdatedEvent(
                  status: '',
                  driverName: '',
                  driverPhone: '',
                  userConfirmed: false,
                ),
              );
              return;
            }
            final data = snapshot.data() as Map<String, dynamic>? ?? {};
            add(
              OrderUpdatedEvent(
                status: data[FirestoreKeys.status] as String? ?? '',
                driverName: data[FirestoreKeys.driverName] as String? ?? '',
                driverPhone: data[FirestoreKeys.driverPhone] as String? ?? '',
                userConfirmed:
                    data[FirestoreKeys.userConfirmed] as bool? ?? false,
              ),
            );
          },
          onError: (_) {
            if (!isClosed) {
              add(
                const OrderUpdatedEvent(
                  status: '',
                  driverName: '',
                  driverPhone: '',
                  userConfirmed: false,
                ),
              );
            }
          },
        );
  }

  void _onOrderUpdated(
    OrderUpdatedEvent event,
    Emitter<TrackOrderState> emit,
  ) {
    emit(
      state.copyWith(
        status: event.status,
        driverName: event.driverName,
        driverPhone: event.driverPhone,
        userConfirmed: event.userConfirmed,
        stepsCompleted: OrderStatus.stepsCompleted(event.status),
        isLoading: false,
      ),
    );
  }

  Future<void> _onConfirmDelivery(
    ConfirmDeliveryEvent event,
    Emitter<TrackOrderState> emit,
  ) async {
    emit(state.copyWith(confirmDeliveryState: BaseState.loading()));
    try {
      await _confirmDeliveryUseCase.execute(event.orderId);
      emit(state.copyWith(
        userConfirmed: true,
        confirmDeliveryState: BaseState.success(null),
      ));
    } catch (e) {
      emit(state.copyWith(
        confirmDeliveryState: BaseState.error(e.toString()),
      ));
    }
  }

  @override
  Future<void> close() async {
    await _orderSubscription?.cancel();
    return super.close();
  }
}
