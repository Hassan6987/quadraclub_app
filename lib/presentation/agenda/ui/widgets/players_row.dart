import 'package:quadraclub_app/presentation/common/widgets/common_plus_avatar.dart';

import '../../../../app_exports.dart';

class PlayersRow extends StatelessWidget {
  final List<Player> players;

  const PlayersRow({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (players.isNotEmpty) _playerSlot(players[0]) else _availableSlot(),

        if (players.length > 1) _playerSlot(players[1]) else _availableSlot(),

        Container(width: 1, height: 24, color: kGreyB8),

        if (players.length > 2) _playerSlot(players[2]) else _availableSlot(),

        if (players.length > 3) _playerSlot(players[3]) else _availableSlot(),
      ],
    );
  }

  Widget _playerSlot(Player player) {
    final bool isAvailable =
        player.role == 'OpenPosition' ||
        player.status == 'Open' ||
        player.id == null;

    if (isAvailable) {
      return _availableSlot();
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

  Widget _availableSlot() {
    return Column(
      children: [
        CommonPlusAvatar(size: 34),
        6.heightBox,
        Text(
          'Available',
          style: AppStyles.w500f14inter.copyWith(
            color: kDarkTextColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          'Open',
          style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
        ),
      ],
    );
  }
}
