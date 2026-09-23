import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/profile/ui/widgets/account_section.dart';
import 'package:quadraclub_app/presentation/profile/ui/widgets/feedback_card.dart';
import 'package:quadraclub_app/presentation/profile/ui/widgets/game_info_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StatFilter _filter = StatFilter.overall;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.user == null) {
          return GuestLoginPrompt(
            title: l10n.profile,
            subtitle: l10n.signInToViewAndManageProfile,
          );
        }

        final user = state.user!;

        return Scaffold(
          backgroundColor: kCardColor,
          appBar: CustomAppBar(title: l10n.profile, centerTile: false),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(user: user),
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
                  preferredSide: user.dominantHand ?? 'Unknown',
                ),
                10.heightBox,
                if(user.feedbackStats.isNotEmpty)
                FeedbackCard(tags: user.feedbackStats),
                8.heightBox,
                const AccountSection(),
              ],
            ).withPaddingSymmetric(20, 8),
          ),
        );
      },
    );
  }
}
