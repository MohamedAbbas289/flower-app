sealed class UpdateProfileEvent {
  const UpdateProfileEvent();
}

class LoadUpdateProfileDataEvent extends UpdateProfileEvent {
  const LoadUpdateProfileDataEvent();
}

class RetryLoadUpdateProfileDataEvent extends UpdateProfileEvent {
  const RetryLoadUpdateProfileDataEvent();
}

