part of 'notification_bloc.dart';

enum NotificationStateStatus {
  initial,
  loading,
  success,
  failure,
  updating,
  deleting,
}

class NotificationState extends Equatable {
  final NotificationStateStatus status;
  final List<NotificationModel> notifications;
  final String? error;

  /// The notification currently being marked-read or deleted, if any.
  final String? processingId;

  const NotificationState({
    this.status = NotificationStateStatus.initial,
    this.notifications = const [],
    this.error,
    this.processingId,
  });

  @override
  List<Object?> get props => [status, notifications, error, processingId];

  bool get hasUnread => notifications.any((n) => !n.isRead);

  NotificationState copyWith({
    NotificationStateStatus? status,
    List<NotificationModel>? notifications,
    String? error,
    String? processingId,
    bool clearProcessingId = false,
    bool clearError = false,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      error: clearError ? null : (error ?? this.error),
      processingId: clearProcessingId
          ? null
          : (processingId ?? this.processingId),
    );
  }
}
