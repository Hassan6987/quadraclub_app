import 'package:dotted_border/dotted_border.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/player_profile_screen.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

import '/app_exports.dart';

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
                          buildSeatsBadge(match),
                        ],
                      ),
                      Text(
                        match.club?.name ?? '',
                        style: AppStyles.w500f14inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                      Text(
                        "${match.club?.city} • ${formatDistanceKm(
                            distanceKm)} • ${getFormatDateMonth(
                            match.bookingDate)}",
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
                CommonBadge(label: match.format.label),
                CommonBadge(label: "Ranking"),
                buildCourtStatusBadge(match),
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
  return Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < match.playersDetail.length; i++) ...[
          buildPlayer(cxt, match.playersDetail[i], onTap),

          // Vertical divider after the occupied players
          if (i == match.playersDetail
              .where((e) => (e.user == null))
              .length - 1 && match.playersDetail.any((e) => e.user != null))
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

Widget buildPlayer(BuildContext cxt, PlayersDetail player,
    VoidCallback? onTap) {
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
            "Available",
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
            builder: (_) => PlayerProfileScreen(player: player),
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
            player.slotName ?? "Beginner",
            style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
          ),
        ],
      ),
    ),
  );
}

Widget buildSeatsBadge(Booking match) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: kRedColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      match.isFull == true
          ? 'Full'
          : '${match.filledSlots} Seat${(match.needsPlayers ?? 0) > 1
          ? 's'
          : ''}',
      style: AppStyles.w400f12inter.copyWith(color: kWhiteColor),
    ),
  );
}

Widget buildCourtStatusBadge(Booking match) {
  final isConfirmed = match.status == CourtStatus.confirmed;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: isConfirmed ? kGreenColor.withValues(alpha: 0.1) : kWhiteColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: isConfirmed ? kGreenColor : kBorderColor),
    ),
    child: Text(
      isConfirmed ? 'Court Confirmed' : 'Pending Confirmed',
      style: AppStyles.w500f10inter.copyWith(
        color: isConfirmed ? kGreenColor : kDarkTextColor,
      ),
    ),
  );
}
