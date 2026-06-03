import 'package:flower_app/features/add_address/data/models/add_address_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/use_cases/add_address_use_cases.dart';
import '../states/add_address_events.dart';
import '../states/add_address_states.dart';

@injectable
class AddAddressCubit extends Cubit<AddAddressStates> {
  final AddAddressUseCases _addAddressUseCase;
  AddAddressCubit(this._addAddressUseCase) : super(const AddAddressStates());
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
    emit(
      state.copyWith(addAddressState: BaseState<List<AddressEntity>>.loading()),
    );
    final response = await _addAddressUseCase(request);
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            addAddressState: BaseState<List<AddressEntity>>.success(
              response.data,
            ),
          ),
        );
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
