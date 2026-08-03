abstract class OrderStatus {
  static const String accepted = 'accepted';
  static const String arrivedPickup = 'arrived_pickup';
  static const String outForDelivery = 'out_for_delivery';
  static const String arrivedUser = 'arrived_user';
  static const String delivered = 'delivered';
  static const String canceled = 'canceled';
  static const String completed = 'completed';

  static int stepsCompleted(String status) {
    const map = {
      accepted: 1,
      arrivedPickup: 2,
      outForDelivery: 3,
      arrivedUser: 4,
      delivered: 4,
    };
    return map[status] ?? 0;
  }
}
