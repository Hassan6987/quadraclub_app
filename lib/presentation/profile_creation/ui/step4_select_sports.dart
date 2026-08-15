import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/profile_creation/data/sport_model.dart';
import 'package:quadraclub_app/presentation/profile_creation/data/sports_data.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/widgets/sport_card.dart';

class Step4SelectSports extends StatefulWidget {
  const Step4SelectSports({super.key});

  @override
  State<Step4SelectSports> createState() => _Step4SelectSportsState();
}

class _Step4SelectSportsState extends State<Step4SelectSports> {
  final List<SportModel> _selectedSports = [];

  final List<SportModel> _sports = SportsData.availableSports;

  void _toggleSport(SportModel sport) {
    setState(() {
      if (_selectedSports.any((s) => s.name == sport.name)) {
        _selectedSports.removeWhere((s) => s.name == sport.name);
      } else {
        _selectedSports.add(sport);
      }
    });
  }

  void _onContinue() {
    if (_selectedSports.isEmpty) {
      return;
    }
    // Navigate to next step
    Navigator.pushNamed(context, RouteName.defineLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileCreationAppBar(
              onBackPressed: () => Navigator.pop(context),
              currentStep: 4,
            ),
            24.heightBox,
            // ✅ Wrap in Expanded so this Column has bounded height
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What games do you play?',
                    style: AppStyles.w600f18inter.copyWith(
                      color: kTextPrimaryColor,
                    ),
                  ),
                  Text(
                    'Select one or more. You can add others later.',
                    style: AppStyles.w400f14inter.copyWith(
                      color: kTextSecondary.withValues(alpha: 0.70),
                    ),
                  ),
                  40.heightBox,
                  Expanded(
                    child: ListView(
                      children: _sports.map((sport) {
                        final isSelected = _selectedSports.any(
                              (s) => s.name == sport.name,
                        );
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: getProportionateScreenHeight(12),
                          ),
                          child: SportCard(
                            sport: sport,
                            isSelected: isSelected,
                            onTap: () => _toggleSport(sport),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  CustomActionButton(
                    buttonText: "Continue with ${_selectedSports.length} sports",
                    onTap: _onContinue,
                    isEnabled: true,
                    backgroundColor: kPrimaryColor,
                    buttonTextColor: kTextPrimaryColor,
                  ),
                  24.heightBox,
                ],
              ).withPaddingSymmetric(24, 0),
            ),
          ],
        ),
      ),
    );
  }
}
