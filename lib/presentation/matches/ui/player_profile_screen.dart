import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/profile/ui/widgets/feedback_card.dart';
import 'package:quadraclub_app/presentation/profile/ui/widgets/game_info_card.dart';

class PlayerProfileScreen extends StatefulWidget {
  final PlayerModel player;

  const PlayerProfileScreen({super.key, required this.player});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  StatFilter _filter = StatFilter.weekly;
  final UserProfile profile = dummyProfile;

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
            // GameInfoCard(info: profile.gameInfo),
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
                  buildInfoRow(label: 'Location', value: "Model Town, Punjab"),
                  8.heightBox,
                  buildInfoRow(label: 'Gender', value: "Masculine"),
                  8.heightBox,
                  buildInfoRow(label: 'Date of Birth', value: "20 May, 1996"),
                ],
              ),
            ),
          ],
        ).withPaddingSymmetric(20, 16),
      ),
    );
  }
}
