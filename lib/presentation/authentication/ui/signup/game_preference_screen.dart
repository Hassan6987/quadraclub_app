import 'package:quadraclub_app/presentation/authentication/data/model/signup_data.dart';
import 'package:quadraclub_app/presentation/authentication/ui/signup/define_level_screen.dart';
import 'package:quadraclub_app/presentation/authentication/ui/signup/onboarding_app_bar.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import '/app_exports.dart';

/// Step 4/5.
class GamesPreferenceScreen extends StatefulWidget {
  final SignupData data;

  const GamesPreferenceScreen({super.key, required this.data});

  @override
  State<GamesPreferenceScreen> createState() => _GamesPreferenceScreenState();
}

class _GamesPreferenceScreenState extends State<GamesPreferenceScreen> {
  static const _sports = ['Padel', 'Tennis', 'Beach Tennis', 'Pickleball'];

  static final Map<String, Object> _sportIcons = {
    'Padel': Assets.svg.padelIcon.path,
    'Tennis': Assets.svg.tennisIcon.path,
    'Beach Tennis': Assets.svg.tennisIcon.path,
    'Pickleball': Assets.svg.tennisIcon.path,
  };

  final Set<String> _selected = {};

  void _toggle(String sport) {
    setState(() {
      if (_selected.contains(sport)) {
        _selected.remove(sport);
      } else {
        _selected.add(sport);
      }
    });
  }

  void _onContinue() {
    if (_selected.isEmpty) return;
    widget.data.selectedSports = _selected.toList();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DefineLevelScreen(data: widget.data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const OnboardingAppBar(currentStep: 4, totalSteps: 5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dim.PADDING_SIZE_LARGE),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.heightBox,
            Text(
              "What games do you play?",
              style: AppStyles.subHeadingSemibold.copyWith(color: kBlackColor),
            ),
            Text(
              "Select one or more. You can add others later.",
              style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
            ),
            24.heightBox,
            Expanded(
              child: ListView.separated(
                itemCount: _sports.length,
                separatorBuilder: (_, __) => 12.heightBox,
                itemBuilder: (context, index) {
                  final sport = _sports[index];
                  final isSelected = _selected.contains(sport);
                  return GestureDetector(
                    onTap: () => _toggle(sport),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFC5E028)
                              : kBorderColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(_sportIcons[sport] as String),
                          12.widthBox,
                          Expanded(
                            child: Text(
                              sport,
                              style: AppStyles.titleRegular.copyWith(
                                color: kBlackColor,
                              ),
                            ),
                          ),
                          Icon(
                            isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: isSelected
                                ? const Color(0xFFC5E028)
                                : kBorderColor,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            CustomActionButton(
              buttonText: _selected.isEmpty
                  ? "Continue"
                  : "Continue with ${_selected.length} sport${_selected.length > 1 ? 's' : ''}",
              onTap: _onContinue,
              isEnabled: _selected.isNotEmpty,
              backgroundColor: const Color(0xFFC5E028),
              buttonTextColor: kBlackColor,
              width: double.infinity,
            ),
            24.heightBox,
          ],
        ),
      ),
    );
  }
}
