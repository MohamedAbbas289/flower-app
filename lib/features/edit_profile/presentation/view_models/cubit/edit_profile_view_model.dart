import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/base_response/base_response.dart';
import '../../../../../config/base_state/base_state.dart';
import '../../../../get_profile_screen/domain/entities/user_entitiy.dart';
import '../../../../get_profile_screen/domain/use_cases/get_profile_use_cases.dart';
import '../../../data/models/edit_user_dto.dart';
import '../../../domain/entities/edit_user_entity.dart';
import '../../../domain/use_cases/edit_profile_use_cases.dart';
import '../states/edit_profile_events.dart';
import '../states/edit_profile_state.dart';

@injectable
class EditProfileViewModel extends Cubit<UpdateProfileState> {
  final EditProfileUseCases _editProfileUseCases;
  final GetProfileUseCases _getProfileUseCases;
  EditProfileViewModel(this._editProfileUseCases, this._getProfileUseCases)
    : super(const UpdateProfileState());

  void doEvent(UpdateProfileEvent event) {
    switch (event) {
      case LoadUpdateProfileDataEvent():
        _loadUpdateProfileData();
      case RetryLoadUpdateProfileDataEvent():
        _retryLoadUpdateProfileData();
      case UpdateProfileDataEvent():
        _updateProfile(event.request);
      case UploadImageEvent():
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void _loadUpdateProfileData() {
    _getProfile();
  }

  void _retryLoadUpdateProfileData() {
    if (state.profileDataState.msg != null) _getProfile();
  }

  Future<void> _getProfile() async {
    emit(state.copyWith(profileDataState: BaseState<GetUserEntity>.loading()));
    final response = await _getProfileUseCases();
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            profileDataState: BaseState<GetUserEntity>.success(response.data),
            selectedGender: response.data.gender ?? state.selectedGender,
          ),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            profileDataState: BaseState<GetUserEntity>.error(
              response.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _updateProfile(EditUserDto request) async {
    emit(
      state.copyWith(updateProfileState: BaseState<EditUserEntity>.loading()),
    );
    final response = await _editProfileUseCases(request);
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            updateProfileState: BaseState<EditUserEntity>.success(
              response.data,
            ),
            selectedGender: response.data.gender ?? state.selectedGender,
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

  void changeGender(String gender) {
    emit(state.copyWith(selectedGender: gender));
  }
}
