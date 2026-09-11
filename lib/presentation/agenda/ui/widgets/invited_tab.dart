import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/invite_player_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/invite_player_sheet.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '../../../../app_exports.dart';

class InvitedTab extends StatefulWidget {
  const InvitedTab({super.key});

  @override
  State<InvitedTab> createState() => _InvitedTabState();
}

class _InvitedTabState extends State<InvitedTab> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaBloc, AgendaState>(
      builder: (context, state) {
        if (state.status == AgendaStateStatus.fetching ||
            state.status == AgendaStateStatus.updating) {
          return Center(child: CustomLoadingView());
        }
        final match = state.matchDetails;
        if (state.status != AgendaStateStatus.fetching && match == null) {
          return const Center(child: Text('Nothing here yet'));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: match!.invited.length,
                separatorBuilder: (_, _) => 12.heightBox,
                itemBuilder: (context, index) {
                  return _invitedPlayerItem(
                      match.invited[index], match.id ?? '');
                },
              ),
            ),
            CommonDivider(),
            CustomActionButton(
              buttonText: 'Invite Players',
              onTap: () async {
                final result = await InvitePlayersSheet.show(
                  context,
                  initiallyInvited: [],
                  allPlayers: state.players
                      .where(
                        (player) =>
                    !state.matchDetails!.invited.any(
                          (invited) => invited.id == player.id,
                    ),
                  )
                      .toList(),
                );
                if (result != null) {
                  context.read<AgendaBloc>().add(
                    InvitePlayers(playerIds: result.map((e) => e.id).toList(),
                        matchId: match.id ?? ''),
                  );
                }
              },
            ).withPaddingSymmetric(24, 16),
          ],
        );
      },
    );
  }

  Widget _invitedPlayerItem(InvitePlayerModel player, String matchId) {
    return Row(
      children: [
        AppCachedImage(
          imageUrl: player.profilePhoto,
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
          onTap: () {
            context.read<AgendaBloc>().add(
                CancelPlayerInvite(playerId: player.id, matchId: matchId));
          },
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
