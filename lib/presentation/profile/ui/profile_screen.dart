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
  StatFilter _filter = StatFilter.weekly;
  final UserProfile profile = dummyProfile;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Show guest prompt when user is not logged in
        if (state.user == null) {
          return const GuestLoginPrompt(
            title: 'Profile',
            subtitle: 'Sign in to view and manage your profile',
          );
        }

        return Scaffold(
          backgroundColor: kCardColor,
          appBar: CustomAppBar(title: "Profile", centerTile: false),
          body: SingleChildScrollView(
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
                AccountSection(),
              ],
            ).withPaddingSymmetric(20, 16),
          ),
        );
      },
    );
  }
}
