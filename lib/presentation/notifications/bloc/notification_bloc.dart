import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/presentation/notifications/data/notification_model.dart';
import 'package:quadraclub_app/presentation/notifications/data/notification_repo.dart';

import '../../../app_exports.dart';
import '../../../di/locator.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepo _repo = locator.get<NotificationRepo>();

  NotificationBloc() : super(const NotificationState()) {
    on<GetAllNotifications>(_handleFetchNotifications);
    on<ClearNotifications>(_handleClearNotifications);
    on<MarkNotificationAsRead>(_handleMarkAsRead);
    on<DeleteNotification>(_handleDeleteNotification);
  }

  Future<void> _handleClearNotifications(
    ClearNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationState());
  }

  Future<void> _handleFetchNotifications(
    GetAllNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: NotificationStateStatus.loading,
          clearError: true,
          clearProcessingId: true,
        ),
      );
      final notifications = await _repo.getAllNotification();
      emit(
        state.copyWith(
          status: NotificationStateStatus.success,
          notifications: notifications,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStateStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _handleMarkAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final alreadyRead = state.notifications.any(
      (n) => n.id == event.id && n.isRead,
    );
    if (alreadyRead) return;

    final previous = state.notifications;

    // Optimistic: flip isRead immediately so the highlight clears on tap.
    emit(
      state.copyWith(
        status: NotificationStateStatus.updating,
        processingId: event.id,
        clearError: true,
        notifications: previous
            .map((n) => n.id == event.id ? n.copyWith(isRead: true) : n)
            .toList(),
      ),
    );

    try {
      await _repo.markNotificationAsRead(event.id);
      emit(
        state.copyWith(
          status: NotificationStateStatus.success,
          clearProcessingId: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStateStatus.failure,
          notifications: previous,
          error: e.toString(),
          clearProcessingId: true,
        ),
      );
    }
  }

  Future<void> _handleDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    final previous = state.notifications;
    final removed = previous.where((n) => n.id != event.id).toList();

    // Optimistic: drop the row as soon as the swipe finishes.
    emit(
      state.copyWith(
        status: NotificationStateStatus.deleting,
        processingId: event.id,
        clearError: true,
        notifications: removed,
      ),
    );

    try {
      await _repo.deleteNotification(event.id);
      emit(
        state.copyWith(
          status: NotificationStateStatus.success,
          clearProcessingId: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStateStatus.failure,
          notifications: previous,
          error: e.toString(),
          clearProcessingId: true,
        ),
      );
    }
  }
}
