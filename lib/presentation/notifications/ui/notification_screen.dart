import 'package:quadraclub_app/presentation/notifications/bloc/notification_bloc.dart';
import 'package:quadraclub_app/presentation/notifications/ui/widgets/notification_tile.dart';

import '/app_exports.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.notifications,
        centerTile: true,
        showBackIcon: true,
        showActions: false,
        titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
        },
        builder: (context, state) {

          return ListView.builder(
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              return NotificationTile(notification: state.notifications[index]);
            },
          );
        },
      ),
    );
  }
}
