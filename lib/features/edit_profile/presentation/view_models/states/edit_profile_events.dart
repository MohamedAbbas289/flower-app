import '../../../data/models/edit_user_dto.dart';

sealed class UpdateProfileEvent {
  const UpdateProfileEvent();
}

class LoadUpdateProfileDataEvent extends UpdateProfileEvent {
  const LoadUpdateProfileDataEvent();
}

class RetryLoadUpdateProfileDataEvent extends UpdateProfileEvent {
  const RetryLoadUpdateProfileDataEvent();
}

class UpdateProfileDataEvent extends UpdateProfileEvent {
  final EditUserDto request;

  const UpdateProfileDataEvent(this.request);
}
