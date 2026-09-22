import 'package:equatable/equatable.dart';
import 'package:quadraclub_app/presentation/notifications/data/notification_model.dart';
import 'package:quadraclub_app/presentation/notifications/data/notification_repo.dart';

import '../../../app_exports.dart';
import '../../../di/locator.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepo _repo = locator.get<NotificationRepo>();
  NotificationBloc() : super(NotificationState()) {
    on<GetAllNotifications>(_handleFetchNotifications);
    on<MarkNotificationAsRead>(_handleMarkAsRead);
    on<DeleteNotification>(_handleDeleteNotification);
  }


  Future<void> _handleFetchNotifications(
      GetAllNotifications event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      emit(state.copyWith(status: NotificationStateStatus.loading));
      final notifications = await _repo.getAllNotification();
      emit(state.copyWith(status: NotificationStateStatus.success, notifications: notifications));
    } catch (e) {
      emit(state.copyWith(status: NotificationStateStatus.failure, error: e.toString()));
    }
  }



  Future<void> _handleMarkAsRead(
      MarkNotificationAsRead event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      emit(state.copyWith(status: NotificationStateStatus.updating));
      await _repo.markNotificationAsRead(event.id);

      final newNotifications = state.notifications.map((notif) {
        return notif.id == event.id
            ? notif.copyWith(isRead: true)
            : notif;
      }).toList();

      emit(state.copyWith(
        status: NotificationStateStatus.success,
        notifications: newNotifications,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationStateStatus.failure,
        error: e.toString(),
      ));
    }
  }


  Future<void> _handleDeleteNotification(
      DeleteNotification event,
      Emitter<NotificationState> emit,
      ) async {
    try {
      emit(state.copyWith(status: NotificationStateStatus.deleting));
      await _repo.deleteNotification(event.id);

      final newNotifications = state.notifications
          .where((notif) => notif.id != event.id)
          .toList();

      emit(state.copyWith(
        status: NotificationStateStatus.success,
        notifications: newNotifications,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NotificationStateStatus.failure,
        error: e.toString(),
      ));
    }
  }


}
