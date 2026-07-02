import 'package:equatable/equatable.dart';
import 'package:flower_app/features/home/data/models/notification_model.dart';

class NotificationState extends Equatable {
  final List<NotificationModel> notifications;

  const NotificationState({this.notifications = const []});

  @override
  List<Object?> get props => [notifications];
}
