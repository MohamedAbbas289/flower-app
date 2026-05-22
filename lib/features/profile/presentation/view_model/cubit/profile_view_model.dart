import 'package:flower_app/config/base_response/base_response.dart';
import 'package:flower_app/config/base_state/base_state.dart';
import 'package:flower_app/core/entities/auth_response_entity.dart';
import 'package:flower_app/features/profile/domain/use_cases/get_profile_data_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../states/get_profile_events.dart';
import '../states/get_profile_state.dart';

@injectable
class ProfileViewModel extends Cubit<GetProfileState> {
  final GetProfileDataUseCases _getProfileDataUseCases;

  ProfileViewModel(this._getProfileDataUseCases)
    : super(const GetProfileState());

  void doEvent(GetProfileEvent event) {
    switch (event) {
      case LoadProfileDataEvent():
        _loadGetProfileData();
      case RetryLoadProfileDataEvent():
        _retryLoadGetProfileData();
      case RefreshProfileEvent():
        _getProfile();
    }
  }

  void _loadGetProfileData() {
    _getProfile();
  }

  void _retryLoadGetProfileData() {
    _getProfile();
  }

  Future<void> _getProfile() async {
    emit(
      state.copyWith(getProfileState: BaseState<AuthResponseEntity>.loading()),
    );
    final response = await _getProfileDataUseCases();
    switch (response) {
      case SuccessBaseResponse():
        emit(
          state.copyWith(
            getProfileState: BaseState<AuthResponseEntity>.success(
              response.data,
            ),
          ),
        );
      case ErrorBaseResponse():
        emit(
          state.copyWith(
            getProfileState: BaseState<AuthResponseEntity>.error(
              response.errorMessage,
            ),
          ),
        );
    }
  }
}
