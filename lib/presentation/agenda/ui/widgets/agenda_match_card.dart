import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/players_row.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

class AgendaMatchCard extends StatelessWidget {
  final AgendaItem item;
  final String? actionLabel;
  final VoidCallback? onTap;

  const AgendaMatchCard(
      {super.key, required this.item, this.actionLabel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kBorderF0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCachedImage(
                  imageUrl: courtImageUrl,
                  // still a placeholder unless API sends one
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(20),
                ),
                8.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SportBadge(sport: SportTypeExtension.fromString(
                              item.sport)),
                          const Spacer(),
                          if (item.seatsTag != null) _seatsBadge(item
                              .seatsTag!),
                        ],
                      ),
                      4.heightBox,
                      Text(item.courtName,
                          style: AppStyles.w600f16inter.copyWith(
                              color: kDarkTextColor)),
                      Text(item.location,
                          style: AppStyles.w400f14inter.copyWith(
                              color: kGreyTextColor)),
                    ],
                  ),
                ),
              ],
            ).withPaddingAll(10),
            4.heightBox,
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                CommonBadge(label: item.dateString),
                CommonBadge(label: item.category),
                if (item.courtStatusLabel != null) _courtConfirmedBadge(
                    item.courtStatusLabel!),
              ],
            ),
            16.heightBox,
            PlayersRow(players: item.players ?? const []),
            if (actionLabel != null)
              CustomActionButton(
                backgroundColor: actionLabel == "Cancel request"
                    ? kLightPinkColor
                    : kPrimaryColor,
                buttonText: actionLabel!,
                onTap: () {
                  if (actionLabel == "Chat") {
                    if (item.chatId != null && item.chatId!.isNotEmpty) {
                      ///todo navigate to chat here
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) =>
                      //         ChatScreen(chat: chat),
                      //   ),
                      // );
                    }
                  }
                },
              ).withPaddingSymmetric(16, 12),
          ],
        ),
      ),
    );
  }

  Widget _seatsBadge(String label) =>
      Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
            color: kRedColor, borderRadius: BorderRadius.circular(16)),
        child: Text(
            label, style: AppStyles.w400f12inter.copyWith(color: kWhiteColor)),
  );

  Widget _courtConfirmedBadge(String label) =>
      Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: kGreen06.withValues(alpha: 0.10),
      border: Border.all(color: kGreen06),
      borderRadius: BorderRadius.circular(16),
    ),
        child: Text(
            label, style: AppStyles.w500f10inter.copyWith(color: kGreen06)),
  );
}
