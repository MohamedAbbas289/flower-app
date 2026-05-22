sealed class GetProfileEvent {
  const GetProfileEvent();
}

class LoadProfileDataEvent extends GetProfileEvent {
  const LoadProfileDataEvent();
}

class RetryLoadProfileDataEvent extends GetProfileEvent {
  const RetryLoadProfileDataEvent();
}

class RefreshProfileEvent extends GetProfileEvent {
  const RefreshProfileEvent();
}
