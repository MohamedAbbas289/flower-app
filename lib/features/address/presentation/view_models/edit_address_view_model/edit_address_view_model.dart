import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/features/address/domain/entities/address_entity.dart';
import 'package:flower_app/features/address/domain/use_cases/edit_address_use_case.dart';
import 'package:flower_app/features/address/presentation/view_models/edit_address_view_model/edit_address_event.dart';
import 'package:flower_app/features/address/presentation/view_models/edit_address_view_model/edit_address_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class EditAddressViewModel extends Cubit<EditAddressStates> {
  final EditAddressUseCase _editAddressUseCase;

  EditAddressViewModel(this._editAddressUseCase)
      : super(const EditAddressStates());

  void doEvent(EditAddressEvent event) {
    switch (event) {
      case SubmitEditAddressEvent():
        _editAddress(id: event.id, event: event);
    }
  }

  Future<void> _editAddress({
    required String id,
    required SubmitEditAddressEvent event,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(
      editAddressState: BaseState<List<AddressEntity>>.loading(),
    ));

    final response = await _editAddressUseCase(
      id: id,
      request: event.request,
    );
    if (isClosed) return;

    switch (response) {
      case SuccessBaseResponse():
        emit(state.copyWith(
          editAddressState: BaseState<List<AddressEntity>>.success(
            response.data,
          ),
        ));
      case ErrorBaseResponse():
        emit(state.copyWith(
          editAddressState: BaseState<List<AddressEntity>>.error(
            response.errorMessage,
          ),
        ));
    }
  }
}