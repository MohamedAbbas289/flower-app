class NotificationToggleState {
  final bool enabled;

  const NotificationToggleState({this.enabled = true});

  NotificationToggleState copyWith({bool? enabled}) {
    return NotificationToggleState(enabled: enabled ?? this.enabled);
  }
}
