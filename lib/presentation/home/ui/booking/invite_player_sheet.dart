// lib/presentation/booking/ui/widgets/invite_players_sheet.dart
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/models/invite_player_model.dart';

class InvitePlayersSheet extends StatefulWidget {
  final List<InvitePlayerModel> initiallyInvited;
  final List<InvitePlayerModel> allPlayers;

  const InvitePlayersSheet({
    super.key,
    required this.initiallyInvited,
    required this.allPlayers,
  });

  static Future<List<InvitePlayerModel>?> show(
    BuildContext context, {
    required List<InvitePlayerModel> initiallyInvited,
    required List<InvitePlayerModel> allPlayers,
  }) {
    return showModalBottomSheet<List<InvitePlayerModel>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => InvitePlayersSheet(
        initiallyInvited: initiallyInvited,
        allPlayers: allPlayers,
      ),
    );
  }

  @override
  State<InvitePlayersSheet> createState() => _InvitePlayersSheetState();
}

class _InvitePlayersSheetState extends State<InvitePlayersSheet> {
  final TextEditingController _searchController = TextEditingController();
  late List<InvitePlayerModel> _invited;
  late List<InvitePlayerModel> _filtered;

  @override
  void initState() {
    super.initState();
    _invited = List.of(widget.initiallyInvited);
    _searchController.addListener(_onSearchChanged);
    _filtered = widget.allPlayers;
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? widget.allPlayers
          : widget.allPlayers
                .where((p) => p.name.toLowerCase().contains(query))
                .toList();
    });
  }

  void _toggleInvite(InvitePlayerModel player) {
    setState(() {
      final alreadyInvited = _invited.any((p) => p.id == player.id);
      if (alreadyInvited) {
        _invited.removeWhere((p) => p.id == player.id);
      } else {
        _invited.add(player);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Invite Players',
                  style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, _invited),
                  child: const Icon(
                    Icons.close,
                    color: kDarkTextColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 4, color: kCardColor),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: kBorderColor),
              ),
              child: Center(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search players...',
                    hintStyle: AppStyles.w400f14inter.copyWith(
                      color: kDarkTextColor.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: AppStyles.w400f14inter,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => 10.heightBox,
              itemBuilder: (context, index) {
                final player = _filtered[index];
                final isInvited = _invited.any((p) => p.id == player.id);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipOval(
                    child: Image.network(
                      player.profilePhoto,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          Assets.png.profilePlaceholder.path,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  title: Text(
                    player.name,
                    style: AppStyles.w500f14inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () => _toggleInvite(player),
                    child: Text(
                      isInvited ? 'CANCEL INVITE' : 'INVITE',
                      style: AppStyles.w600f12inter.copyWith(
                        color: isInvited ? kRedColor : kBlueColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
