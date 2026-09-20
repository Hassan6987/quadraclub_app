import 'package:dotted_border/dotted_border.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/player_profile_screen.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

import '/app_exports.dart';

String localizedMatchCategory(BuildContext context, String category) {
  final l10n = AppLocalizations.of(context)!;
  switch (category) {
    case 'Open':
      return l10n.categoryOpen;
    case 'Category 1':
      return l10n.category1;
    case 'Category 2':
      return l10n.category2;
    case 'Category 3':
      return l10n.category3;
    default:
      return category;
  }
}

class MatchCard extends StatelessWidget {
  final Booking match;
  final VoidCallback onTap;
  final double distanceKm;

  const MatchCard({
    super.key,
    required this.match,
    required this.onTap,
    required this.distanceKm,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Opacity(
      opacity: match.isFull == true ? 0.7 : 1,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(12),
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kWhiteFo),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Sport badge, seats, court status
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AppCachedImage(
                    imageUrl: match.club?.photo ?? '',
                    width: 64,
                    height: 64,
                  ),
                ),
                8.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SportBadge(sport: match.sport),
                          buildSeatsBadge(context, match),
                        ],
                      ),
                      Text(
                        match.club?.name ?? '',
                        style: AppStyles.w500f14inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                      Text(
                        "${match.club?.city} • ${formatDistanceKm(distanceKm, l10n)} • ${getFormatDateMonth(match.bookingDate, locale: l10n.localeName)}",
                        style: AppStyles.w400f14inter.copyWith(
                          color: kGreyTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            8.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonBadge(label: '${match.startTime}-${match.endTime}'),
                CommonBadge(
                  label: localizedMatchCategory(context, match.category),
                ),
                CommonBadge(label: l10n.ranking),
                buildCourtStatusBadge(context, match),
              ],
            ),
            // Players row
            buildPlayersRow(context, match, onTap),
          ],
        ).withPaddingAll(12),
      ),
    );
  }
}

Widget buildPlayersRow(BuildContext cxt, Booking match, VoidCallback? onTap) {
  final totalSlots = match.format == MatchFormat.singles ? 2 : 4;

  return Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < match.playersDetail.length; i++) ...[
          buildPlayer(cxt, match.playersDetail[i], onTap),

          // Divider always sits at the midpoint of the format
          // (after slot 1 of 2 for singles, after slot 2 of 4 for doubles),
          // regardless of how many slots are filled vs. open.
          if (i == (totalSlots ~/ 2) - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 48,
                child: VerticalDivider(color: kBorderColor, thickness: 1),
              ),
            ),
        ],
      ],
    ),
  );
}

Widget buildPlayer(
  BuildContext cxt,
  PlayersDetail player,
  VoidCallback? onTap,
) {
  if (player.user == null) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: DottedBorder(
              options: CircularDottedBorderOptions(
                color: kDottedBorderColor,
                strokeWidth: 2,
                dashPattern: const [4, 3],
              ),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kWhiteF9,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.add,
                  color: kDottedBorderColor,
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(cxt)!.available,
            style: AppStyles.w500f14inter.copyWith(color: kGreyTextColor),
          ),
          if (player.slotName != null)
            Text(
              player.slotName!,
              style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
            ),
        ],
      ),
    );
  }

  return Expanded(
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          cxt,
          MaterialPageRoute(
            builder: (_) =>
                PlayerProfileScreen(playerId: player.user?.id ?? ''),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: player.user?.profilePhoto != null
                  ? Image.network(player.user!.profilePhoto!, fit: BoxFit.cover)
                  : Container(
                      color: kGreyColor,
                      child: const Icon(Icons.person),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            player.user?.fullName ?? '',
            overflow: TextOverflow.ellipsis,
            style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
          ),
          Text(
            player.slotName ?? AppLocalizations.of(cxt)!.beginner,
            style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
          ),
        ],
      ),
    ),
  );
}

Widget buildSeatsBadge(BuildContext context, Booking match) {
  final l10n = AppLocalizations.of(context)!;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: kRedColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      match.isFull == true
          ? l10n.full
          : l10n.seatsCount(match.needsPlayers ?? 0),
      style: AppStyles.w400f12inter.copyWith(color: kWhiteColor),
    ),
  );
}

Widget buildCourtStatusBadge(BuildContext context, Booking match) {
  final l10n = AppLocalizations.of(context)!;
  final isConfirmed = match.status == CourtStatus.confirmed;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: isConfirmed ? kGreenColor.withValues(alpha: 0.1) : kWhiteColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: isConfirmed ? kGreenColor : kBorderColor),
    ),
    child: Text(
      isConfirmed ? l10n.courtConfirmed : l10n.pendingConfirmed,
      style: AppStyles.w500f10inter.copyWith(
        color: isConfirmed ? kGreenColor : kDarkTextColor,
      ),
    ),
  );
}
