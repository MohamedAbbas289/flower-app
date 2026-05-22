import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../domain/entities/edit_user_entity.dart';
import '../../../domain/use_cases/edit_profile_use_cases.dart';
import '../states/edit_profile_events.dart';
import '../states/edit_profile_state.dart';
@injectable

class EditProfileViewModel extends Cubit <UpdateProfileState> {

  final EditProfileUseCases _editProfileUseCases;
  EditProfileViewModel(this._editProfileUseCases)
      : super(const UpdateProfileState());

  void doEvent(UpdateProfileEvent event) {
    switch (event) {
      case LoadUpdateProfileDataEvent():
        _loadUpdateProfileData();
      case RetryLoadUpdateProfileDataEvent():
        _retryLoadUpdateProfileData();
    }
  }

  void _loadUpdateProfileData() {
    _updateProfile();
  }

  void _retryLoadUpdateProfileData() {
    if (state.updateProfileState.msg != null) _updateProfile();
  }

  Future<void> _updateProfile() async {
    emit(state.copyWith(updateProfileState: BaseState<EditUserEntity>.loading()));
    final response = await _editProfileUseCases();
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            updateProfileState: BaseState<EditUserEntity>.success(response.data),
          ),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            updateProfileState: BaseState<EditUserEntity>.error(
              response.errorMessage,
            ),
          ),
        );
    }
  }

}


