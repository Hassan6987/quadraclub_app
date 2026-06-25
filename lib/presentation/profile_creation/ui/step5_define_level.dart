import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/profile_creation/data/sport_model.dart';
import 'package:quadraclub_app/presentation/profile_creation/data/sports_data.dart';
import 'package:quadraclub_app/presentation/profile_creation/widgets/sport_dropdown.dart';

class Step5DefineLevel extends StatefulWidget {
  const Step5DefineLevel({super.key});

  @override
  State<Step5DefineLevel> createState() => _Step5DefineLevelState();
}

class _Step5DefineLevelState extends State<Step5DefineLevel> {
  final Map<String, String?> _selectedCategories = {};
  final List<String> categories = const [
    'Open',
    'Category 1',
    'Category 2',
    'Category 3',
  ];
  final Map<String, String> categoryDescriptions = const {
    'Open': 'Open to all players',
    'Category 1': 'Beginner level players',
    'Category 2': 'Intermediate level players',
    'Category 3': 'Advanced level players',
  };
  String _preferredSide = 'Both';

  final List<SportModel> _sports = SportsData.availableSports;

  void _onCategoryChanged(String sport, String? category) {
    setState(() {
      _selectedCategories[sport] = category;
    });
  }


  void _onCompleteRegistration() {
    Navigator.pushNamed(context, RouteName.confirmation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileCreationAppBar(
              onBackPressed: () => Navigator.pop(context),
              currentStep: 5,
            ),
            24.heightBox,

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Define your level.',
                      style: AppStyles.w600f18inter.copyWith(
                        color: kTextPrimaryColor,
                      ),
                    ),

                    Text(
                      'Select your category for each sport. You can change it later.',
                      style: AppStyles.w400f14inter.copyWith(
                        color: kTextSecondary.withValues(alpha: 0.70),
                      ),
                    ),
                    40.heightBox,
                    ..._sports.map((sport) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SportDropdown(
                            sportName: sport.name,
                            selectedCategory: _selectedCategories[sport.name],
                            categories: categories,
                            categoryDescriptions: categoryDescriptions,
                            sportIcon: sport.icon,
                            onCategoryChanged: (category) =>
                                _onCategoryChanged(sport.name, category),

                          ),
                          16.heightBox,
                          if (sport.name == 'Padel') ...[
                            Text(
                              'Preferred Side',
                              style: AppStyles.w500f14inter.copyWith(
                                color: kDarkTextColor,
                              ),
                            ),

                            Row(
                              spacing: getProportionateScreenWidth(8),

                              children: ['Left', 'Right', 'Both'].map((side) {
                                return Expanded(
                                  child: SelectionButton(
                                    label: side,
                                    borderRadius: 16,
                                    verticalPadding: 6,
                                    isSelected: _preferredSide == side,
                                    onTap: () {
                                      setState(() {
                                        _preferredSide = side;
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                            24.heightBox,

                          ],
                        ],
                      );
                    }),

                    CustomActionButton(buttonText: 'Complete Registration',
                        buttonTextColor: kDarkTextColor,
                        onTap: _onCompleteRegistration),
                    24.heightBox,
                  ],
                ).withPaddingSymmetric(24, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
