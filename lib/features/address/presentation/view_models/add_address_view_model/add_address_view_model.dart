import 'dart:async';

import 'package:flower_app/config/firebase/last_address_firestore_service.dart';
import 'package:flower_app/features/address/api/request_models/add_address_request_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/use_cases/add_address_use_case.dart';
import 'add_address_events.dart';
import 'add_address_states.dart';

@injectable
class AddAddressViewModel extends Cubit<AddAddressStates> {
  final AddAddressUseCase _addAddressUseCase;
  final LastAddressFirestoreService _lastAddressFirestoreService;

  AddAddressViewModel(this._addAddressUseCase, this._lastAddressFirestoreService)
    : super(const AddAddressStates());

  void doEvent(AddAddressEvent event) {
    switch (event) {
      case AddAddressDataEvent():
        _addAddress(event.request);
    }
  }

  Future<void> _addAddress(AddAddressRequestModel request) async {
    if (isClosed) return;
    emit(
      state.copyWith(addAddressState: BaseState<List<AddressEntity>>.loading()),
    );
    final response = await _addAddressUseCase.execute(request: request);
    if (isClosed) return;
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            addAddressState: BaseState<List<AddressEntity>>.success(
              response.data,
            ),
          ),
        );
        if (response.data.isNotEmpty) {
          unawaited(
            _lastAddressFirestoreService.saveLastAddress(response.data.last),
          );
        }
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            addAddressState: BaseState<List<AddressEntity>>.error(
              response.errorMessage,
            ),
          ),
        );
    }
  }
}
