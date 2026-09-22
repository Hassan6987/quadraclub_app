import 'package:quadraclub_app/presentation/notifications/bloc/notification_bloc.dart';
import 'package:quadraclub_app/presentation/notifications/ui/widgets/notification_tile.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(GetAllNotifications());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBar(
        title: l10n.notifications,
        centerTile: true,
        showBackIcon: true,
        showActions: false,
        titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listenWhen: (previous, current) =>
            current.status == NotificationStateStatus.failure &&
            current.error != null &&
            current.error != previous.error,
        listener: (context, state) {
          context.showToast(
            state.error ?? l10n.somethingWentWrong,
            isError: true,
          );
        },
        builder: (context, state) {
          final isInitialLoad =
              state.status == NotificationStateStatus.loading ||
              state.status == NotificationStateStatus.initial;

          if (isInitialLoad && state.notifications.isEmpty) {
            return const Center(child: CustomLoadingView());
          }

          if (state.status == NotificationStateStatus.failure &&
              state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.error ?? l10n.somethingWentWrong,
                    textAlign: TextAlign.center,
                    style: AppStyles.w500f14inter.copyWith(color: kTextColor),
                  ),
                  12.heightBox,
                  TextButton(
                    onPressed: () => context.read<NotificationBloc>().add(
                      GetAllNotifications(),
                    ),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state.notifications.isEmpty) {
            return Center(
              child: Text(
                l10n.nothingHereYet,
                style: AppStyles.w600f18inter.copyWith(color: kDarkTextColor),
              ),
            );
          }

          return RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: () async {
              context.read<NotificationBloc>().add(GetAllNotifications());
              await context.read<NotificationBloc>().stream.firstWhere(
                (s) =>
                    s.status == NotificationStateStatus.success ||
                    s.status == NotificationStateStatus.failure,
              );
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationTile(
                  notification: notification,
                  isProcessing: state.processingId == notification.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
