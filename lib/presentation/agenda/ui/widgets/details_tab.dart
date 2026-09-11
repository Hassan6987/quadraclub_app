import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/agenda/data/model/agenda_detail_model.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/common/widgets/common_plus_avatar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart';

class DetailsTab extends StatelessWidget {
  const DetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaBloc, AgendaState>(
      builder: (context, state) {
        if (state.status == AgendaStateStatus.fetching) {
          return Center(child: CustomLoadingView());
        }
        final match = state.matchDetails;
        if (state.status != AgendaStateStatus.fetching && match == null) {
          return const Center(child: Text('Nothing here yet'));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _venueCard(match!).withPaddingSymmetric(20, 16),
            16.heightBox,
            _tagsRow(match).withPaddingSymmetric(20, 0),
            16.heightBox,
            CommonDivider(),
            16.heightBox,
            _playersSection(match),
            16.heightBox,
            _groupChatSection(),
            Spacer(),
            CommonDivider(),
            CustomActionButton(
              buttonText: "Leave this match",
              onTap: () {
                context.pop();
                context.read<AgendaBloc>().add(
                    LeaveMatchEvent(matchId: match.id ?? ''));
              },
              backgroundColor: kLightPinkColor,
            ).withPaddingSymmetric(24, 16),
          ],
        );
      },
    );
  }

  Widget _venueCard(AgendaMatchDetails match) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCachedImage(
          imageUrl: courtImageUrl,
          height: 64,
          width: 64,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(20),
        ),
        8.widthBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match.title ?? "",
              style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
            ),
            4.heightBox,
            Text(
              match.location ?? '',
              style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
            ),
            4.heightBox,
            Text(
              match.dateFormatted ?? '',
              style: AppStyles.w500f12inter.copyWith(color: kLightGreenColor),
            ),
          ],
        ),
        12.heightBox,
      ],
    );
  }

  Widget _tagsRow(AgendaMatchDetails match) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        CommonBadge(label: '${match.startTime} ${match.endTime}'),
        CommonBadge(label: match.categoryTag ?? "D"),
        const CommonBadge(label: 'Ranking'),
        CourtConfirmationBadge(label: match.courtStatus ?? "Court Confirmed"),
      ],
    );
  }

  Widget _playersSection(AgendaMatchDetails match) {
    final players = match.players;
    // For Single format, there are 2 player slots.
    // You can extend this later for other formats.
    final int maxPlayers = match.format?.toLowerCase() == 'single' ? 2 : 4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Players',
              style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
            ),
            SportBadge(sport: SportTypeExtension.fromString(match.sport ?? '')),
          ],
        ),
        16.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (players.isNotEmpty)
              _playerItem(players[0])
            else
              _availablePlayerItem(),
            if (players.length > 1)
              _playerItem(players[1])
            else
              _availablePlayerItem(), // Divider only for 4-player formats
            if (maxPlayers > 2) ...[
              Container(
                height: 24,
                width: 1,
                color: kGreyTextColor,
              ), // Player 3
              if (players.length > 2)
                _playerItem(players[2])
              else
                _availablePlayerItem(), // Player 4
              if (players.length > 3)
                _playerItem(players[3])
              else
                _availablePlayerItem(),
            ],
          ],
        ),
      ],
    ).withPaddingSymmetric(20, 0);
  }

  Widget _playerItem(Player player) {
    return Column(
      children: [
        AppCachedImage(
          imageUrl: player.profilePhoto,
          height: 48,
          width: 48,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(48),
        ),
        6.heightBox,
        Text(
          player.name,
          style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
        ),
        Text(
          player.level,
          style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
        ),
      ],
    );
  }

  Widget _groupChatSection() {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          CommonAvatarStackRow(
            imageUrls: [playerOneImageUrl, playerTwoImageUrl],
            maxVisible: 2,
            avatarSize: 32,
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Group Chat',
                  style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
                ),
                Text(
                  'Chat with players',
                  style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
                ),
              ],
            ),
          ),
          CustomActionButton(
            buttonText: 'Chat',
            onTap: () {},
            width: 84,
            height: 40,
          ),
        ],
      ),
    ).withPaddingSymmetric(20, 0);
  }

  Widget _availablePlayerItem() {
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
