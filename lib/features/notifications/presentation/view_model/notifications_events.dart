sealed class NotificationsEvent {}

class GetNotificationsEvent extends NotificationsEvent {
  final int? page;
  final int? limit;

  GetNotificationsEvent({this.page, this.limit});
}
