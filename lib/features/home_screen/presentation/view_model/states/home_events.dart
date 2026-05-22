sealed class HomeEvent {
  const HomeEvent();
}

class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

class RetryLoadHomeDataEvent extends HomeEvent {
  const RetryLoadHomeDataEvent();
}

class RefreshHomeEvent extends HomeEvent {
  const RefreshHomeEvent();
}
