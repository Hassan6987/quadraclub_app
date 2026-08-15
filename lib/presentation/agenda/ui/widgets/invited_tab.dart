import '../../../../app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/ui/widgets/invite_players_bottom_sheet.dart';

class InvitedTab extends StatelessWidget {
  final List<InvitedPlayer> _invitedPlayers = [
    InvitedPlayer(name: 'Alex Rivers', imageUrl: playerOneImageUrl),
    InvitedPlayer(name: 'John Doe', imageUrl: playerTwoImageUrl),
    InvitedPlayer(name: 'Robert Smith', imageUrl: playerOneImageUrl),
  ];

  InvitedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: _invitedPlayers.length,
            separatorBuilder: (_, _) => 12.heightBox,
            itemBuilder: (context, index) {
              final player = _invitedPlayers[index];
              return _invitedPlayerItem(player);
            },
          ),
        ),
        CommonDivider(),
        CustomActionButton(
          buttonText: 'Invite Players',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const InvitePlayersBottomSheet(),
            );
          },
        ).withPaddingSymmetric(24, 16),
      ],
    );
  }

  Widget _invitedPlayerItem(InvitedPlayer player) {
    return Row(
      children: [
        AppCachedImage(
          imageUrl: player.imageUrl,
          height: 48,
          width: 48,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(999),
        ),
        12.widthBox,
        Expanded(
          child: Text(
            player.name,
            style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kBorderColor),
            ),
            child: const Icon(Icons.close, color: kRedColor, size: 18),
          ),
        ),
      ],
    );
  }
}
