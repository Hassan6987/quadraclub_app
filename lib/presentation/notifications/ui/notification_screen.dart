import 'package:quadraclub_app/presentation/notifications/data/notification_model.dart';
import 'package:quadraclub_app/presentation/notifications/ui/widgets/notification_tile.dart';
import '/app_exports.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        centerTile: true,
        showBackIcon: true,
        showActions: false,
        titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
      ),
      body: ListView.builder(
        itemCount: dummyNotifications.length,

        itemBuilder: (context, index) {
          return NotificationTile(notification: dummyNotifications[index]);
        },
      ),
    );
  }
}
