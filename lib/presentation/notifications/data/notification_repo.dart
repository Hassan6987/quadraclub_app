import 'package:quadraclub_app/presentation/notifications/data/notification_model.dart';
import 'package:quadraclub_app/presentation/notifications/data/notification_services.dart';

import '../../../di/locator.dart';

class NotificationRepo {
  final NotificationServices _services = locator.get<NotificationServices>();

  Future<List<NotificationModel>> getAllNotification() async {
    try {
      final response = await _services.getAllNotifications();
      final data = response.data as Map<String, dynamic>;
      final List<dynamic> notifJson =
          data['notifications'] as List<dynamic>? ?? [];
      return notifJson
          .map(
            (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markNotificationAsRead(String id) async {
    try {
      await _services.markNotificationAsRead(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _services.deleteNotification(id);
    } catch (e) {
      rethrow;
    }
  }
}
