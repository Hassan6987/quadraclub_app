import 'package:quadraclub_app/presentation/common/widgets/common_plus_avatar.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';

import '../../../../app_exports.dart';

class PlayersRow extends StatelessWidget {
  final List<Player> players;
  final MatchFormat format;

  const PlayersRow({super.key, required this.players, required this.format});

  @override
  Widget build(BuildContext context) {
    final totalSlots = format == MatchFormat.singles ? 2 : 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (int i = 0; i < totalSlots; i++) ...[
          if (players.length > i)
            _playerSlot(context, players[i])
          else
            _availableSlot(context),

          // Divider sits in the middle: after slot 1 of 2 (singles),
          // or after slot 2 of 4 (doubles).
          if (i == (totalSlots ~/ 2) - 1)
            Container(width: 1, height: 24, color: kGreyB8),
        ],
      ],
    );
  }

  Widget _playerSlot(BuildContext context, Player player) {
    final bool isAvailable =
        player.role == 'OpenPosition' ||
        player.status == 'Open' ||
        player.id == null;

    if (isAvailable) {
      return _availableSlot(context);
    }

    return _player(player);
  }

  Widget _player(Player player) {
    return Column(
      children: [
        AppCachedImage(
          imageUrl: player.profilePhoto,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(40),
        ),
        6.heightBox,
        Text(
          player.name,
          style: AppStyles.w500f14inter.copyWith(
            color: kDarkTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          player.level,
          style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
        ),
      ],
    );
  }

  Widget _availableSlot(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        CommonPlusAvatar(size: 34),
        6.heightBox,
        Text(
          l10n.available,
          style: AppStyles.w500f14inter.copyWith(
            color: kDarkTextColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          l10n.open,
          style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
        ),
      ],
    );
  }
}