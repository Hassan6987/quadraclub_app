import 'package:quadraclub_app/presentation/home/data/scanned_team_model.dart';
import 'package:quadraclub_app/presentation/team_roster/bloc/team_roster_bloc.dart';
import 'package:quadraclub_app/presentation/teams/bloc/teams_bloc.dart';
import 'package:quadraclub_app/presentation/teams/ui/team_player_detail.dart';
import 'package:quadraclub_app/utils/components/alert_dialogue.dart';
import 'package:quadraclub_app/utils/components/blue_app_bar.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

import '../../../../app_exports.dart';

class TeamRosterScreen extends StatelessWidget {
  const TeamRosterScreen({super.key});

  void _showAddAthleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => CustomAlertDialog(
          title: 'Add Athlete to Roster',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to add this athlete to roster?',
                style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
                textAlign: TextAlign.center,
              ),
            ],
          ).withPaddingSymmetric(16, 0),
          onButtonTap: () {
            context.read<TeamRosterBloc>().add(AddPlayerToRoster(playerId: id));
            context.read<TeamsBloc>().add(AddPlayerInRoster(athleteId: id));
            Navigator.pop(context);
          },
          leftButtonText: 'No',
          rightButtonText: 'Yes',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlueAppBar(
        title: "Scanned Team Roster",
        showBackArrow: true,
        height: 100,
      ),
      body: BlocBuilder<TeamsBloc, TeamsState>(
        builder: (context, state) {
          final scannedTeam = state.scannedTeam;
          final roster = state.scannedTeam?.athletes ?? [];
          if (scannedTeam == null) {
            return const Center(
              child: Text(
                'No team scanned yet.',
                style: TextStyle(fontSize: 16, color: kPrimaryColor),
              ),
            );
          }
          return CustomScrollView(
            slivers: [
              // ── Team Info Card ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kCardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scannedTeam.name,
                              style: AppStyles.subtitleMedium.copyWith(
                                color: kBlackColor,
                              ),
                            ),
                            10.heightBox,
                            Wrap(
                              spacing: 8,
                              children: [
                                InfoChip(
                                  icon: Icons.location_on_outlined,
                                  label: scannedTeam.city ?? '—',
                                ),
                                InfoChip(
                                  icon: Icons.people_outline,
                                  label: scannedTeam.ageGroup ?? '—',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Season Year',
                            style: AppStyles.subtitleMedium.copyWith(
                              color: kBlackColor,
                            ),
                          ),
                          10.heightBox,
                          Text(
                            scannedTeam.seasonYear?.toString() ?? '—',
                            style: AppStyles.bodyRegular.copyWith(
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Section Title ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'All Team Players',
                    style: AppStyles.titleSemibold.copyWith(color: kBlackColor),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: 8.heightBox),

              // ── Player List ─────────────────────────────────────────
              roster.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Text(
                            'No players in this team yet.',
                            style: TextStyle(
                              fontSize: 14,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final athlete = roster[index];
                        return PlayerCard(
                          athlete: athlete,
                          teamName: scannedTeam.name,
                          onAddToRoster: athlete.inRoster
                              ? null
                              : () =>
                                    _showAddAthleteDialog(context, athlete.id),
                        );
                      }, childCount: roster.length),
                    ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          );
        },
      ),
    );
  }
}

// ─── Info Chip ───────────────────────────────────────────────────────────────

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: kPrimaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: kPrimaryColor),
          4.widthBox,
          Text(
            label,
            style: AppStyles.bodyRegular.copyWith(color: kPrimaryColor),
          ),
        ],
      ),
    );
  }
}

// ─── Player Card ─────────────────────────────────────────────────────────────

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.athlete,
    required this.onAddToRoster,
    required this.teamName,
  });

  final ScannedTeamAthlete athlete;
  final String teamName;

  /// Null means the player is already in the roster — button shows as disabled.
  final VoidCallback? onAddToRoster;

  @override
  Widget build(BuildContext context) {
    final imageUrl = athlete.image;
    final alreadyAdded = athlete.inRoster;

    return InkWell(
      onTap: () {
        context.read<TeamsBloc>().add(
          FetchAthleteHistory(athleteId: athlete.id),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                TeamPlayerDetailScreen(athlete: athlete, teamName: teamName),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Avatar ──────────────────────────────────────────────
            CircleAvatar(
              radius: 28,
              backgroundColor: kCardColor,
              backgroundImage: (imageUrl != null && imageUrl.startsWith('http'))
                  ? NetworkImage(imageUrl)
                  : null,
              child: (imageUrl == null || !imageUrl.startsWith('http'))
                  ? const Icon(Icons.person, size: 28, color: kSecondaryColor)
                  : null,
            ),
            6.widthBox,

            // ── Name + Position ──────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    athlete.fullName,
                    style: AppStyles.subtitleMedium.copyWith(
                      color: kBlackColor,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    athlete.position ?? '—',
                    style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
                  ),
                ],
              ),
            ),

            // ── Grad Year + Roster Button ────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  athlete.graduationYear?.toString() ?? '—',
                  style: AppStyles.bodyRegular.copyWith(color: kPrimaryColor),
                ),
                6.heightBox,
                GestureDetector(
                  onTap: onAddToRoster,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: alreadyAdded
                          ? kCardColor.withValues(alpha: 0.5)
                          : kSecondaryColor.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: alreadyAdded
                            ? kSecondaryColor.withValues(alpha: 0.35)
                            : kSecondaryColor,
                      ),
                    ),
                    child: Text(
                      alreadyAdded ? 'In Roster' : 'Add to Roster',
                      style: AppStyles.subtitleMedium.copyWith(
                        color: alreadyAdded
                            ? kSecondaryColor.withValues(alpha: 0.45)
                            : kSecondaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
