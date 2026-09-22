part of 'notification_bloc.dart';

class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class GetAllNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final String id;

  const MarkNotificationAsRead({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteNotification extends NotificationEvent {
  final String id;

  const DeleteNotification({required this.id});

  @override
  List<Object?> get props => [id];
}
