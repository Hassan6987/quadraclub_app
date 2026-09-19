import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_invitation_model.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/players_row.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_card.dart';

class AgendaInvitationCard extends StatelessWidget {
  final AgendaInvitation item;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const AgendaInvitationCard({
    super.key,
    required this.item,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kPrimaryColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCachedImage(
                imageUrl: item.clubImage,
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
                        SportBadge(
                          sport: SportTypeExtension.fromString(item.sport),
                        ),
                        const Spacer(),
                        _invitedByBadge(context, item.hostName),
                      ],
                    ),
                    4.heightBox,
                    Text(
                      item.courtName,
                      style: AppStyles.w600f16inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                    Text(
                      item.location,
                      style: AppStyles.w400f14inter.copyWith(
                        color: kGreyTextColor,
                      ),
                    ),
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
              CommonBadge(
                label: localizedMatchCategory(context, item.category),
              ),
              _courtConfirmedBadge(item.courtStatusLabel),
            ],
          ).withPaddingSymmetric(10, 0),
          16.heightBox,
          PlayersRow(players: item.players, format: item.format),
          16.heightBox,
          Row(
            children: [
              Expanded(
                child: _iconActionButton(
                  icon: Icons.close_rounded,
                  color: kRedColor,
                  label: AppLocalizations.of(context)!.decline,
                  onTap: onReject,
                ),
              ),
              12.widthBox,
              Expanded(
                child: _iconActionButton(
                  icon: Icons.check_rounded,
                  color: kPrimaryColor,
                  label: AppLocalizations.of(context)!.accept,
                  onTap: onAccept,
                  filled: true,
                ),
              ),
            ],
          ).withPaddingSymmetric(16, 12),
        ],
      ),
    );
  }

  Widget _invitedByBadge(BuildContext context, String hostName) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: kPrimaryColor.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      AppLocalizations.of(context)!.invitedBy(hostName),
      style: AppStyles.w400f12inter.copyWith(color: kPrimaryColor),
    ),
  );

  Widget _courtConfirmedBadge(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: kGreen06.withValues(alpha: 0.10),
      border: Border.all(color: kGreen06),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(label, style: AppStyles.w500f10inter.copyWith(color: kGreen06)),
  );

  Widget _iconActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: filled ? color : kWhiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: filled ? 0 : 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: filled ? kWhiteColor : color),
            6.widthBox,
            Text(
              label,
              style: AppStyles.w500f14inter.copyWith(
                color: filled ? kWhiteColor : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
