import 'dart:async';

import 'package:flower_app/config/firebase/last_address_firestore_service.dart';
import 'package:flower_app/features/address/data/models/add_address_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/use_cases/add_address_use_cases.dart';
import 'add_address_events.dart';
import 'add_address_states.dart';

@injectable
class AddAddressCubit extends Cubit<AddAddressStates> {
  final AddAddressUseCases _addAddressUseCase;
  final LastAddressFirestoreService _lastAddressFirestoreService;

  AddAddressCubit(this._addAddressUseCase, this._lastAddressFirestoreService)
    : super(const AddAddressStates());
  void doEvent(AddAddressEvent event) {
    switch (event) {
      case LoadAddressDataEvent():
        _loadAddressData();
      case RetryLoadAddressDataEvent():
        _retryLoadAddressData();
      case AddAddressDataEvent():
        _addAddress(event.request);
    }
  }

  void _loadAddressData() {}

  void _retryLoadAddressData() {}

  Future<void> _addAddress(AddAddressDto request) async {
    if (isClosed) return;
    emit(
      state.copyWith(addAddressState: BaseState<List<AddressEntity>>.loading()),
    );
    final response = await _addAddressUseCase(request);
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
