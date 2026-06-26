import 'dart:async';

import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/config/firebase/last_address_firestore_service.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/shopping/domain/entities/payment_method.dart';
import 'package:flower_app/features/shopping/presentation/view_models/checkout_view_model/checkout_events.dart';
import 'package:flower_app/features/shopping/presentation/view_models/checkout_view_model/checkout_states.dart';
import 'package:flower_app/features/shopping/api/request_models/payment_request_model.dart';
import 'package:flower_app/features/shopping/domain/use_cases/create_cash_order_use_case.dart';
import 'package:flower_app/features/shopping/domain/use_cases/get_checkout_session_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/saved_address_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckoutViewModel extends Cubit<CheckoutStates> {
  final GetAddressesUseCase _getAddressesUseCase;
  final LastAddressFirestoreService _lastAddressFirestoreService;
  final CreateCashOrderUseCase _createCashOrderUseCase;
  final GetCheckoutSessionUseCase _getCheckoutSessionUseCase;

  CheckoutViewModel(
    this._getAddressesUseCase,
    this._lastAddressFirestoreService,
    this._createCashOrderUseCase,
    this._getCheckoutSessionUseCase,
  ) : super(const CheckoutStates());

  void doEvent(CheckoutEvent event) {
    switch (event) {
      case LoadCheckoutDataEvent():
        _loadAddresses();
      case SelectAddressEvent():
        emit(state.copyWith(selectedAddress: event.address));
      case SelectPaymentMethodEvent():
        emit(state.copyWith(paymentMethod: event.method));
      case ToggleGiftEvent():
        emit(state.copyWith(isGift: event.value));
      case PlaceOrderEvent():
        _placeOrder(giftName: event.giftName, giftPhone: event.giftPhone);
    }
  }

  Future<void> _loadAddresses() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        addressesState: BaseState<List<AddressEntity>>.loading(),
      ),
    );

    final response = await _getAddressesUseCase.execute();
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse():
        final addresses = response.data;
        final selected = await _resolveDefaultAddress(addresses);
        if (isClosed) return;
        emit(
          state.copyWith(
            addressesState: BaseState<List<AddressEntity>>.success(
              addresses,
            ),
            selectedAddress: selected,
          ),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            addressesState: BaseState<List<AddressEntity>>.error(
              response.errorMessage,
            ),
          ),
        );
    }
  }

  Future<AddressEntity?> _resolveDefaultAddress(
    List<AddressEntity> addresses,
  ) async {
    if (addresses.isEmpty) return null;

    final lastAddress = await _lastAddressFirestoreService.getLastAddress();
    if (lastAddress != null) {
      final matches = addresses.where((a) => a.id == lastAddress.id);
      if (matches.isNotEmpty) return matches.first;
    }

    return addresses.last;
  }

  Future<void> _placeOrder({String? giftName, String? giftPhone}) async {
    if (isClosed) return;
    final address = state.selectedAddress;
    if (address == null) return;

    emit(
      state.copyWith(
        placeOrderState: BaseState<PlaceOrderResult>.loading(),
      ),
    );

    final requestModel = PaymentRequestModel.fromAddress(address);

    if (state.paymentMethod == PaymentMethod.cash) {
      final response = await _createCashOrderUseCase.execute(request: requestModel);
      if (isClosed) return;
      switch (response) {
        case SuccessBaseResponse():
          emit(
            state.copyWith(
              placeOrderState: BaseState<PlaceOrderResult>.success(
                CashOrderPlaced(response.data.orderNumber ?? ''),
              ),
            ),
          );
          unawaited(_lastAddressFirestoreService.saveLastAddress(address));
        case ErrorBaseResponse():
          emit(
            state.copyWith(
              placeOrderState: BaseState<PlaceOrderResult>.error(
                response.errorMessage,
              ),
            ),
          );
      }
    } else {
      final response = await _getCheckoutSessionUseCase.execute(request: requestModel);
      if (isClosed) return;
      switch (response) {
        case SuccessBaseResponse():
          emit(
            state.copyWith(
              placeOrderState: BaseState<PlaceOrderResult>.success(
                StripeSessionCreated(response.data.sessionUrl ?? ''),
              ),
            ),
          );
        case ErrorBaseResponse():
          emit(
            state.copyWith(
              placeOrderState: BaseState<PlaceOrderResult>.error(
                response.errorMessage,
              ),
            ),
          );
      }
    }
  }
}
