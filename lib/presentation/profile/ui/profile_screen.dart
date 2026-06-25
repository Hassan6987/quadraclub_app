import 'package:quadraclub_app/app_exports.dart';
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
    return Scaffold(
      backgroundColor: kCardColor,
      appBar: CustomAppBar(title: "Profile"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(profile: profile),
            24.heightBox,
            StatisticsCard(
              stats: profile.stats,
              selected: _filter,
              onFilterChanged: (f) => setState(() => _filter = f),
            ),
            8.heightBox,
            GameInfoCard(info: profile.gameInfo),
            8.heightBox,
            FeedbackCard(tags: profile.feedback),
            8.heightBox,
            AccountSection(),
          ],
        ).withPaddingSymmetric(20, 16),
      ),
    );
  }
}

