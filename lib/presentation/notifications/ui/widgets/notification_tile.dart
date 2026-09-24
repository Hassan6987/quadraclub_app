import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/chats/ui/my_chats_screen.dart';
import 'package:quadraclub_app/presentation/notifications/bloc/notification_bloc.dart';
import 'package:quadraclub_app/presentation/notifications/data/notification_model.dart';

import '../../../../app_exports.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final bool isProcessing;

  const NotificationTile({
    super.key,
    required this.notification,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool highlighted = !notification.isRead;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: kRedColor,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete_outline, color: kWhiteColor, size: 28),
      ),
      onDismissed: (_) {
        context.read<NotificationBloc>().add(
          DeleteNotification(id: notification.id),
        );
      },
      child: InkWell(
        onTap: isProcessing ? null : () => _onTap(context),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: highlighted
                    ? kPrimaryColor.withValues(alpha: 0.30)
                    : kWhiteColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: AppStyles.w500f14inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                        2.heightBox,
                        Text(
                          notification.message,
                          style: AppStyles.w500f12inter.copyWith(
                            color: kTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  12.widthBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        notification.timeAgo(l10n),
                        style: AppStyles.w400f12inter.copyWith(
                          color: kTextColor,
                        ),
                      ),
                      if (isProcessing) ...[
                        16.heightBox,
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ] else if (highlighted) ...[
                        20.heightBox,
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: kOrangeColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ).withPaddingSymmetric(24, 16),
            ),
            const Divider(color: kBorderColor, height: 1, thickness: 1),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    if (!notification.isRead) {
      context.read<NotificationBloc>().add(
        MarkNotificationAsRead(id: notification.id),
      );
    }

    _navigateToDestination(context);
  }

  void _navigateToDestination(BuildContext context) {
    // Agenda tabs: 0 = Confirmed, 1 = Pending, 2 = Past.
    if (notification.isMatchInvite) {
      _openAgenda(context, agendaTabIndex: 1);
      return;
    }

    if (notification.isMessage) {
      _openMessage(context);
      return;
    }

    if (notification.isMatchInviteAccepted ||
        notification.isJoinAccepted ||
        notification.isJoinRejected) {
      _openAgenda(context, agendaTabIndex: 0);
      return;
    }

    if (notification.isMatchInviteRejected) {
      _openMatchDetails(context, MatchDetailsTab.invited);
      return;
    }

    if (notification.isJoinRequest) {
      _openMatchDetails(context, MatchDetailsTab.requests);
      return;
    }

    // Unknown type — land on Agenda Confirmed.
    _openAgenda(context, agendaTabIndex: 0);
  }

  void _openAgenda(BuildContext context, {required int agendaTabIndex}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteName.customBottomNavbar,
      (_) => false,
      arguments: {"index": 3, "agendaTabIndex": agendaTabIndex},
    );
  }

  void _openMessage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyChatsScreen(),
      ),
    );
  }

  void _openMatchDetails(BuildContext context, MatchDetailsTab initialTab) {
    final bookingId = notification.bookingId;

    if (bookingId == null || bookingId.isEmpty) {
      _openAgenda(context, agendaTabIndex: 0);
      return;
    }

    context.read<AgendaBloc>().add(GetMatchDetails(id: bookingId));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MatchDetailsScreen(initialTab: initialTab),
      ),
    );
  }
}
