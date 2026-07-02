class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.isRead,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      receivedAt: receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
