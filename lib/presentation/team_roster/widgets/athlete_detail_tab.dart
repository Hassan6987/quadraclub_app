import 'package:quadraclub_app/presentation/athletes/ui/athlete_detail_shimmer.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/home/bloc/home_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/rating_model.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/video_player_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/videos_list_widget.dart';
import 'package:quadraclub_app/presentation/team_roster/bloc/team_roster_bloc.dart';
import 'package:quadraclub_app/presentation/teams/ui/player_detail_tab.dart';
import 'package:quadraclub_app/utils/components/alert_dialogue.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';
import '/app_exports.dart';

class AthleteDetailTab extends StatelessWidget {
  final int athleteId;

  const AthleteDetailTab({super.key, required this.athleteId});

  void _showRemoveAthleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => CustomAlertDialog(
          title: 'Remove Athlete',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to remove athlete from roster?',
                style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
                textAlign: TextAlign.center,
              ),
            ],
          ).withPaddingSymmetric(16, 0),
          onButtonTap: () {
            context.read<TeamRosterBloc>().add(
              RemovePlayerFromRoster(playerId: athleteId),
            );
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAthleteCard(context),
          _buildAthleteMetrics(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<TeamRosterBloc, TeamRosterState>(
              builder: (context, state) {
                if (state.status == RosterStateStatus.deleting) {
                  return Center(child: CustomLoadingView());
                }
                return CustomActionButton(
                  buttonText: "Remove from Roster",
                  onTap: () => _showRemoveAthleteDialog(context),
                );
              },
            ),
          ),
          100.heightBox,
        ],
      ),
    );
  }

  // ─── Sections ────────────────────────────────────────────────────────────────

  Widget _buildAthleteCard(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStateStatus.fetching) {
          return const AthleteProfileShimmer();
        } else if (state.currentAthlete == null) {
          return Center(
            child: Text(
              'Athlete not found',
              style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
            ),
          );
        }

        final athlete = state.currentAthlete!;

        // Get current user's ID and find their existing rating
        final myId = context.read<AuthBloc>().state.user!.id;
        RatingModel? myExistingRating;
        try {
          myExistingRating = state.athleteRatings.firstWhere(
            (rating) =>
                rating.ratedBy?.providedBy.toString() == myId.toString(),
          );
        } catch (e) {
          myExistingRating = null;
        }

        return Container(
          margin: EdgeInsets.all(Dim.PADDING_SIZE_DEFAULT),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F4E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: kWhiteColor,
                radius: 50,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: athlete.scannedUserProfile?.image != null
                      ? NetworkImage(athlete.scannedUserProfile!.image!)
                      : null,
                  child: athlete.scannedUserProfile?.image == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
              ),
              8.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: kSecondaryColor, size: 24),
                  4.widthBox,
                  Text(
                    athlete.scannedUserProfile?.averageRating?.toStringAsFixed(
                          1,
                        ) ??
                        '',
                    style: AppStyles.subtitleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kBlackColor,
                    ),
                  ),
                ],
              ),
              16.heightBox,
              _buildInfoRow(
                'Full Name',
                athlete.scannedUserProfile?.fullName ?? 'Unknown',
              ),
              _buildInfoRow('Email', athlete.email ?? 'N/A'),
              _buildInfoRow(
                'Graduation Year',
                athlete.scannedUserProfile?.graduationYear.toString() ??
                    'unknown',
              ),
              _buildInfoRow(
                'Team',
                athlete.scannedUserProfile?.teamName ?? 'unknown',
              ),
              _buildInfoRow(
                'Position',
                athlete.scannedUserProfile?.position ?? 'unknown',
              ),
              if (myExistingRating != null)
                _buildInfoRow('You Rate', '⭐ ${myExistingRating.rating ?? 0}'),
              if (athlete.scannedUserProfile?.transcript != null)
                _buildTranscriptField(
                  context,
                  athlete.scannedUserProfile!.transcript!,
                ),
              if (athlete.scannedUserProfile?.highlightVideos != null &&
                  athlete.scannedUserProfile!.highlightVideos!.isNotEmpty)
                _buildHighlightedVideos(
                  context,
                  athlete.scannedUserProfile!.highlightVideos!
                      .map((v) => v.video ?? '')
                      .where((url) => url.isNotEmpty)
                      .toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAthleteMetrics(BuildContext context) {
    return BlocBuilder<TeamRosterBloc, TeamRosterState>(
      builder: (context, state) {
        if ((state.status == RosterStateStatus.fetched ||
                state.status == RosterStateStatus.deleting) &&
            (state.completedEvents.isNotEmpty ||
                state.timelineMetrics.isNotEmpty)) {
          return DetailTab(
            completedEvents: state.completedEvents,
            isAthleteInRoster: false,
            timelineMetrics: state.timelineMetrics,
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
          ),
          Text(value, style: AppStyles.bodyMedium.copyWith(color: kBlackColor)),
        ],
      ),
    );
  }

  Widget _buildTranscriptField(BuildContext context, String transcript) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transcript',
            style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              'Transcript.pdf',
              style: AppStyles.bodyMedium.copyWith(
                color: kPrimaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedVideos(BuildContext context, List<String> videos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Highlighted Videos',
            style: AppStyles.bodyRegular.copyWith(color: kBlackColor),
          ),
        ),
        8.heightBox,
        VideoListWidget(
          videoUrls: videos,
          itemHeight: 50,
          isFromHome: false,
          spacing: 8,
          onVideoTap: (videoUrl) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VideoPlayerScreen(videoUrl: videoUrl),
            ),
          ),
        ),
      ],
    );
  }
}
