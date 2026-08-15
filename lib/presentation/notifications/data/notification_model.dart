enum NotificationType { invitation, matchConfirmed, matchCancelled }

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final String locationAndTime;
  final String timeAgo;
  final bool isUnread;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.locationAndTime,
    required this.timeAgo,
    this.isUnread = false,
  });
}

// ─── Dummy Data ───────────────────────────────────────────────────────────────

final List<NotificationModel> dummyNotifications = [
  NotificationModel(
    id: '1',
    type: NotificationType.invitation,
    title: 'Invitation to departure',
    message: 'Carlos Silva invited you to a game.',
    locationAndTime: 'Location & Time: Tennis Club SP 18:00',
    timeAgo: '5min',
    isUnread: true,
  ),
  NotificationModel(
    id: '2',
    type: NotificationType.matchConfirmed,
    title: 'Match confirmed',
    message: 'Their match was confirmed with 4 players.',
    locationAndTime: 'Location & Time: Olympic Village Sports 09:00',
    timeAgo: '5min',
    isUnread: false,
  ),
  NotificationModel(
    id: '3',
    type: NotificationType.matchCancelled,
    title: 'Match cancelled',
    message: 'Their match was confirmed with 4 players.',
    locationAndTime: 'Location & Time: Olympic Village Sports 09:00',
    timeAgo: '14hr',
    isUnread: false,
  ),
];