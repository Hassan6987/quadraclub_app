import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/matches/bloc/matches_bloc.dart';
import 'package:quadraclub_app/presentation/profile/ui/widgets/feedback_card.dart';
import 'package:quadraclub_app/presentation/profile/ui/widgets/game_info_card.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

class PlayerProfileScreen extends StatefulWidget {
  final String playerId;

  const PlayerProfileScreen({super.key, required this.playerId});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  StatFilter _filter = StatFilter.weekly;
  final UserProfile profile = dummyProfile;

  @override
  void initState() {
    context.read<MatchesBloc>().add(FetchPlayerDetails(id: widget.playerId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCardColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kBorderColor),
            ),
            child: Icon(Icons.arrow_back, size: 24, color: kDarkTextColor),
          ),
        ),
        title: Text(
          'Player Details',
          style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<MatchesBloc, MatchesState>(
        builder: (context, state) {
          if (state.status == MatchesStateStatus.fetching) {
            return Center(child: CustomLoadingView());
          } else if (state.status != MatchesStateStatus.fetching &&
              state.user == null) {
            return Center(child: Text("No player data found"));
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(profile: profile, user: state.user),
                24.heightBox,
                StatisticsCard(
                  stats: profile.stats,
                  selected: _filter,
                  onFilterChanged: (f) => setState(() => _filter = f),
                ),
                8.heightBox,
                GameInfoCard(
                  dominantHand: state.user?.dominantHand ?? "Unknown",
                  preferredSide: state.user?.dominantHand ?? 'Unknown',
                ),
                8.heightBox,
                FeedbackCard(tags: profile.feedback),
                8.heightBox,
                CommonCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Player',
                        style: AppStyles.w500f14inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                      16.heightBox,
                      buildInfoRow(
                          label: 'Location', value: state.user?.location ?? ''),
                      8.heightBox,
                      buildInfoRow(
                          label: 'Gender', value: state.user?.gender ?? ''),
                      8.heightBox,
                      buildInfoRow(
                          label: 'Date of Birth',
                          value: getFormatDateMonthYear(state.user
                              ?.dateOfBirth)),
                    ],
                  ),
                ),
              ],
            ).withPaddingSymmetric(20, 16),
          );
        },
      ),
    );
  }
}
