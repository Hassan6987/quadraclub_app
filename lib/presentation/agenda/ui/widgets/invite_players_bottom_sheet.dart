import '../../../../app_exports.dart';

class InvitePlayersBottomSheet extends StatefulWidget {
  const InvitePlayersBottomSheet({super.key});

  @override
  State<InvitePlayersBottomSheet> createState() =>
      _InvitePlayersBottomSheetState();
}

class _InvitePlayersBottomSheetState extends State<InvitePlayersBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  final List<PlayerInvite> _players = [
    PlayerInvite(
      name: 'Alex Rivers',
      imageUrl: playerOneImageUrl,
      isInvited: true,
    ),
    PlayerInvite(
      name: 'John Doe',
      imageUrl: playerTwoImageUrl,
      isInvited: false,
    ),
    PlayerInvite(
      name: 'Robert Smith',
      imageUrl: playerOneImageUrl,
      isInvited: false,
    ),
    PlayerInvite(
      name: 'Michael Johnson',
      imageUrl: playerTwoImageUrl,
      isInvited: false,
    ),
    PlayerInvite(
      name: 'David Wilson',
      imageUrl: playerOneImageUrl,
      isInvited: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.7,
      decoration: const BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _header().withPaddingSymmetric(24, 22),
          CommonDivider(),
          _searchBar().withPaddingSymmetric(24, 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: _players.length,
              separatorBuilder: (_, _) => 12.heightBox,
              itemBuilder: (context, index) {
                final player = _players[index];
                return _playerItem(player, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Text(
          'Invite Players',
          style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pop(context),

          child: const Icon(Icons.close, color: kDarkTextColor, size: 18),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return CustomTextField(
      controller: _searchController,
      hintText: "Search players...",
      borderRadius: 999,
    );
  }

  Widget _playerItem(PlayerInvite player, int index) {
    return Row(
      children: [
        AppCachedImage(
          imageUrl: player.imageUrl,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(999),
        ),
        12.widthBox,
        Expanded(
          child: Text(
            player.name,
            style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _players[index] = PlayerInvite(
                name: player.name,
                imageUrl: player.imageUrl,
                isInvited: !player.isInvited,
              );
            });
          },
          child: Text(
            player.isInvited ? 'CANCEL INVITE' : 'INVITE',
            style: AppStyles.w600f12inter.copyWith(
              color: player.isInvited ? kRed5B : kBlueColor,
            ),
          ),
        ),
      ],
    );
  }
}
