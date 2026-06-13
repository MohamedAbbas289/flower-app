import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/delivery_location/domain/entities/delivery_address_display.dart';
import 'package:flower_app/features/delivery_location/domain/use_cases/resolve_delivery_address_use_case.dart';
import 'package:flower_app/features/delivery_location/presentation/view_model/states/delivery_address_events.dart';
import 'package:flower_app/features/delivery_location/presentation/view_model/states/delivery_address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeliveryAddressViewModel extends Cubit<DeliveryAddressState> {
  final ResolveDeliveryAddressUseCase _resolveDeliveryAddressUseCase;

  DeliveryAddressViewModel(this._resolveDeliveryAddressUseCase)
    : super(const DeliveryAddressState());

  void doEvent(DeliveryAddressEvent event) {
    switch (event) {
      case LoadDeliveryAddressEvent():
        _loadDeliveryAddress();
    }
  }

  Future<void> _loadDeliveryAddress() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        deliveryAddressState: BaseState<DeliveryAddressDisplay>.loading(),
      ),
    );

    final result = await _resolveDeliveryAddressUseCase();

    if (isClosed) return;
    emit(
      state.copyWith(
        deliveryAddressState: BaseState<DeliveryAddressDisplay>.success(
          result,
        ),
      ),
    );
  }
}
