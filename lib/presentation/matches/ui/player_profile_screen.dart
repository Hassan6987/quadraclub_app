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
  StatFilter _filter = StatFilter.overall;

  String _localizedGender(AppLocalizations l10n, String? gender) {
    switch (gender) {
      case 'Masculine':
        return l10n.masculine;
      case 'Feminine':
        return l10n.feminine;
      case 'Prefer not to say':
        return l10n.preferNotToSay;
      default:
        return gender ?? '';
    }
  }

  @override
  void initState() {
    context.read<MatchesBloc>().add(FetchPlayerDetails(id: widget.playerId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: kCardColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kBorderColor),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: kDarkTextColor,
            ),
          ),
        ),
        title: Text(
          l10n.playerDetails,
          style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<MatchesBloc, MatchesState>(
        builder: (context, state) {
          if (state.status == MatchesStateStatus.fetching) {
            return const Center(child: CustomLoadingView());
          } else if (state.status != MatchesStateStatus.fetching &&
              state.user == null) {
            return Center(child: Text(l10n.noPlayerDataFound));
          }

          final user = state.user!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(user: user, canEditSports: false),
                24.heightBox,
                StatisticsCard(
                  matchesCompleted: user.matchesCompleted,
                  victories: user.victories,
                  defeats: user.defeats,
                  selected: _filter,
                  onFilterChanged: (f) => setState(() => _filter = f),
                ),
                8.heightBox,
                GameInfoCard(
                  dominantHand: user.dominantHand ?? 'Unknown',
                  preferredSide:
                      user.sportsInfo
                          .map((s) => s.preferredSide)
                          .whereType<String>()
                          .where((s) => s.isNotEmpty)
                          .firstOrNull ??
                      'Unknown',
                ),
                8.heightBox,
                if (user.feedbackStats.isNotEmpty)
                  FeedbackCard(tags: user.feedbackStats),
                8.heightBox,
                CommonCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.aboutPlayer,
                        style: AppStyles.w500f14inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                      16.heightBox,
                      buildInfoRow(
                        label: l10n.location,
                        value: user.location ?? '',
                      ),
                      8.heightBox,
                      buildInfoRow(
                        label: l10n.gender,
                        value: _localizedGender(l10n, user.gender),
                      ),
                      8.heightBox,
                      buildInfoRow(
                        label: l10n.dateOfBirth,
                        value: getFormatDateMonthYear(
                          user.dateOfBirth,
                          locale: l10n.localeName,
                        ),
                      ),
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
