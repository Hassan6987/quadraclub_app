import 'package:quadraclub_app/presentation/authentication/data/model/signup_data.dart';
import 'package:quadraclub_app/presentation/authentication/ui/signup/game_preference_screen.dart';
import 'package:quadraclub_app/presentation/authentication/ui/signup/onboarding_app_bar.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import '/app_exports.dart';

/// Step 3/5.
class AboutYouScreen extends StatefulWidget {
  final SignupData data;

  const AboutYouScreen({super.key, required this.data});

  @override
  State<AboutYouScreen> createState() => _AboutYouScreenState();
}

class _AboutYouScreenState extends State<AboutYouScreen> {
  final _locationController = TextEditingController();
  String? _gender;
  String? _dominantHand;

  bool get _isButtonEnabled =>
      _locationController.text.isNotEmpty && _gender != null &&
          _dominantHand != null;

  Future<void> _useMyLocation() async {
    // TODO: wire up geolocator/permission_handler here later.
    // Requesting permission (e.g. Geolocator.requestPermission()) is what
    // triggers the native OS "Allow location" dialog shown in the design —
    // that dialog is drawn by the OS, not something to build in Flutter.
    // final position = await Geolocator.getCurrentPosition();
    // then reverse-geocode into a city/area string and set _locationController.text
  }

  void _onContinue() {
    if (!_isButtonEnabled) return;
    widget.data
      ..location = _locationController.text.trim()
      ..gender = _gender
      ..dominantHand = _dominantHand;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => GamesPreferenceScreen(data: widget.data)),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Widget _choiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Widget? icon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: selected
                ? kPrimaryColor.withValues(alpha: 0.2)
                : kWhiteColor,
            border: Border.all(
                color: selected ? kPrimaryColor : kBorderColor, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon, 8.heightBox],
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppStyles.subtitleRegular.copyWith(color: kBlackColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const OnboardingAppBar(currentStep: 3, totalSteps: 5),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dim.PADDING_SIZE_LARGE),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.heightBox,
            Text(
              "About you",
              style: AppStyles.subHeadingSemibold.copyWith(color: kBlackColor),
            ),
            Text(
              "This helps you find courts and players near you.",
              style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
            ),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Location",
                  style: AppStyles.subtitleMedium.copyWith(
                      color: kTextPrimaryColor),
                ),
                TextButton.icon(
                  onPressed: _useMyLocation,
                  icon: const Icon(Icons.location_on_outlined, size: 18),
                  label: const Text("Use my location"),
                ),
              ],
            ),
            CustomTextField(
              controller: _locationController,
              hintText: "City/area",
            ),
            24.heightBox,
            Text(
              "Gender",
              style: AppStyles.subtitleMedium.copyWith(
                  color: kTextPrimaryColor),
            ),
            8.heightBox,
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                "Masculine",
                "Feminine",
                "Prefer not to say",
              ].map((gender) {
                return _choiceChip(
                  label: gender,
                  selected: _gender == gender,
                  onTap: () {
                    setState(() {
                      _gender = gender;
                    });
                  },
                );
              }).toList(),
            ),
            24.heightBox,
            Text(
              "Dominant Hand",
              style: AppStyles.subtitleMedium.copyWith(
                  color: kTextPrimaryColor),
            ),
            12.heightBox,
            Row(
              children: [
                _choiceChip(
                  label: "Left",
                  selected: _dominantHand == "Left",
                  icon: SvgPicture.asset(Assets.svg.leftHand.path),
                  onTap: () => setState(() => _dominantHand = "Left"),
                ),
                _choiceChip(
                  label: "Right",
                  selected: _dominantHand == "Right",
                  icon: SvgPicture.asset(Assets.svg.rightHand.path),
                  onTap: () => setState(() => _dominantHand = "Right"),
                ),
              ],
            ),
            40.heightBox,
            CustomActionButton(
              buttonText: "Continue",
              onTap: _onContinue,
              isEnabled: _isButtonEnabled,
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