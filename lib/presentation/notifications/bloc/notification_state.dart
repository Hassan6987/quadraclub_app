part of 'notification_bloc.dart';

enum NotificationStateStatus {initial, loading, success, failure, updating, deleting}

class NotificationState extends Equatable {
  final NotificationStateStatus status;
  final List<NotificationModel> notifications;
  final String? error;

  const NotificationState({this.status = NotificationStateStatus.initial, this.notifications = const [], this.error});

  @override
  List<Object?> get props => [status, notifications, error];

  NotificationState copyWith({
    NotificationStateStatus? status,
    List<NotificationModel>? notifications,
    String? error,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      error: error ?? this.error
    );
  }
}
