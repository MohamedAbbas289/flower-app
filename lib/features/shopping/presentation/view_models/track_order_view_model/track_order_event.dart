sealed class TrackOrderEvent {
  const TrackOrderEvent();
}

class StartListeningEvent extends TrackOrderEvent {
  final String orderId;
  const StartListeningEvent(this.orderId);
}

class OrderUpdatedEvent extends TrackOrderEvent {
  final String status;
  final String driverName;
  final String driverPhone;
  final bool userConfirmed;

  const OrderUpdatedEvent({
    required this.status,
    required this.driverName,
    required this.driverPhone,
    required this.userConfirmed,
  });
}

class ConfirmDeliveryEvent extends TrackOrderEvent {
  final String orderId;
  const ConfirmDeliveryEvent(this.orderId);
}

