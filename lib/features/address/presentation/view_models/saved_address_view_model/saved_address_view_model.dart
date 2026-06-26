import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/delete_address_use_case.dart';
import 'package:flower_app/features/address/domain/use_cases/saved_address_use_case.dart';
import 'package:flower_app/features/address/presentation/view_models/saved_address_view_model/saved_address_events.dart';
import 'package:flower_app/features/address/presentation/view_models/saved_address_view_model/saved_address_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class SavedAddressViewModel extends Cubit<SavedAddressStates> {
  final GetAddressesUseCase _getAddressesUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;

  SavedAddressViewModel(this._getAddressesUseCase, this._deleteAddressUseCase)
    : super(const SavedAddressStates());

  @override
  void emit(SavedAddressStates state) {
    if (isClosed) return;
    super.emit(state);
  }

  void doEvent(SavedAddressEvent event) {
    switch (event) {
      case LoadAddressesEvent():
        _getAddresses();
      case DeleteAddressEvent():
        _deleteAddress(event.id);
    }
  }

  Future<void> _getAddresses() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        getAddressesState: BaseState<List<AddressEntity>>.loading(),
      ),
    );

    final response = await _getAddressesUseCase.execute();

    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            getAddressesState: BaseState<List<AddressEntity>>.success(
              response.data,
            ),
          ),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            getAddressesState: BaseState<List<AddressEntity>>.error(
              response.errorMessage,
            ),
          ),
        );
    }
  }

 Future<void> _deleteAddress(String id) async {
  if (isClosed) return;
  emit(state.copyWith(
    deleteAddressState: BaseState<bool>.loading(),
  ));

  final response = await _deleteAddressUseCase.execute(id: id);

  switch (response) {
    case SuccessBaseResponse():
      final updatedList = state.getAddressesState.data
              ?.where((e) => e.id != id)
              .toList() ??
          [];
      emit(state.copyWith(
        deleteAddressState: BaseState<bool>.success(true),
        getAddressesState: BaseState<List<AddressEntity>>.success(
          updatedList,
        ),
      ));
    case ErrorBaseResponse():
      emit(state.copyWith(
        deleteAddressState: BaseState<bool>.error(response.errorMessage),
      ));
  }
}
}
