sealed class HomeEvent {
  const HomeEvent();
}

class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

class RetryLoadHomeDataEvent extends HomeEvent {
  const RetryLoadHomeDataEvent();
}

