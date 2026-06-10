import 'package:flower_app/features/saved_address/domain/use_cases/saved_address_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../../../core/models/auth_response.dart';
import '../states/saved_address_event.dart';
import '../states/saved_address_state.dart';
@injectable

class SavedAddressViewModel extends Cubit<SavedAddressState> {
  final SavedAddressUseCase _savedAddressUseCase;
  SavedAddressViewModel(this._savedAddressUseCase )
      : super(const SavedAddressState());
  void doEvent(SavedAddressEvent event) {
    switch (event) {
      case LoadSavedAddressEvent():
        _loadSavedAddress();
      case RetryLoadSavedAddressEvent():
        _retryLoadSavedAddress();
      case RefreshSavedAddressEvent():
        _getSavedAddress();
    }
  }

  void _loadSavedAddress() {
    _getSavedAddress();
  }

  void _retryLoadSavedAddress() {
    _getSavedAddress();
  }

  void _getSavedAddress() async{
    emit(
      state.copyWith(getSavedAddressState: BaseState<AuthResponse>.loading()),
    );
    final response = await _savedAddressUseCase();
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            getSavedAddressState: BaseState<AuthResponse>.success(
              response.data,
            ),
          ),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            getSavedAddressState: BaseState<AuthResponse>.error(
              response.errorMessage,
            ),
          ),
        );
    }



  }

}