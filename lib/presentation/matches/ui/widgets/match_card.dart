import 'package:quadraclub_app/presentation/classes/ui/widgets/common_badge.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import '/app_exports.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final VoidCallback onTap;

  const MatchCard({super.key, required this.match, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: match.status == MatchStatus.full ? null : onTap,
      child: Opacity(
        opacity: match.status == MatchStatus.full ? 0.7 : 1,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(12),
          ),
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
                  SportBadge(sport: match.sport),
                  4.widthBox,
                  CommonBadge(label: match.category),
                  4.widthBox,
                  CommonBadge(label: match.format.label),
                  const Spacer(),
                  _buildSeatsBadge(),
                ],
              ),
              8.heightBox,
              
              // Location and distance
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.svg.locationIcon.path,
                    height: 16,
                    width: 16,
                    colorFilter: ColorFilter.mode(kGreyTextColor, BlendMode.srcIn),
                  ),
                  4.widthBox,
                  Expanded(
                    child: Text(
                      match.location,
                      style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
                    ),
                  ),
                  4.widthBox,
                  Text(
                    '${match.distanceKm} mi',
                    style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
                  ),
                ],
              ),
              4.heightBox,
              
              // Time and date
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.svg.clockTimer.path,
                    height: 16,
                    width: 16,
                    colorFilter: ColorFilter.mode(kGreyTextColor, BlendMode.srcIn),
                  ),
                  4.widthBox,
                  Text(
                    '${match.timeStart}-${match.timeEnd}',
                    style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                  ),
                  8.widthBox,
                  _buildCourtStatusBadge(),
                ],
              ),
              Divider(color: kBorderColor).withPaddingSymmetric(0, 8),
              
              // Players row
              _buildPlayersRow(),
            ],
          ).withPaddingAll(12),
        ),
      ),
    );
  }

  Widget _buildSeatsBadge() {
    if (match.status == MatchStatus.full) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: kGreyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Full',
          style: AppStyles.w500f10inter.copyWith(color: kDarkTextColor),
        ),
      );
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kRedColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kRedColor),
      ),
      child: Text(
        '${match.slotsLeft} Seat${match.slotsLeft > 1 ? 's' : ''}',
        style: AppStyles.w500f10inter.copyWith(color: kRedColor),
      ),
    );
  }

  Widget _buildCourtStatusBadge() {
    final isConfirmed = match.courtStatus == CourtStatus.confirmed;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isConfirmed 
            ? kGreenColor.withValues(alpha: 0.1)
            : kGreyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConfirmed ? kGreenColor : kGreyTextColor,
        ),
      ),
      child: Text(
        isConfirmed ? 'Court Confirmed' : 'Pending Confirmed',
        style: AppStyles.w500f10inter.copyWith(
          color: isConfirmed ? kGreenColor : kGreyTextColor,
        ),
      ),
    );
  }

  Widget _buildPlayersRow() {
    return Row(
      children: [
        ...match.players.take(4).map((player) => _buildPlayerAvatar(player)),
        if (match.players.length > 4) ...[
          4.widthBox,
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: kGreyColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '+${match.players.length - 4}',
                style: AppStyles.w500f10inter.copyWith(color: kDarkTextColor),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlayerAvatar(PlayerModel player) {
    if (player.isAvailable) {
      return Padding(
        padding: EdgeInsets.only(right: 8),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: kGreyColor,
                shape: BoxShape.circle,
                border: Border.all(color: kBorderColor),
              ),
              child: Icon(
                Icons.add,
                size: 16,
                color: kDarkTextColor,
              ),
            ),
            2.heightBox,
            Text(
              player.position ?? 'Available',
              style: AppStyles.w500f8inter.copyWith(color: kGreyTextColor),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: kGreyColor,
              shape: BoxShape.circle,
            ),
            child: player.avatarAsset != null
                ? ClipOval(
                    child: Image.asset(
                      player.avatarAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person, size: 16, color: kGreyTextColor);
                      },
                    ),
                  )
                : Icon(Icons.person, size: 16, color: kGreyTextColor),
          ),
          2.heightBox,
          Text(
            player.name,
            style: AppStyles.w500f8inter.copyWith(color: kGreyTextColor),
          ),
        ],
      ),
    );
  }
}
