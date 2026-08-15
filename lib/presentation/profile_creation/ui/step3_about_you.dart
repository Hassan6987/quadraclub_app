import 'package:quadraclub_app/app_exports.dart';


class Step3AboutYou extends StatefulWidget {
  const Step3AboutYou({super.key});

  @override
  State<Step3AboutYou> createState() => _Step3AboutYouState();
}

class _Step3AboutYouState extends State<Step3AboutYou> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();

  String _selectedGender = 'Masculine';
  String _selectedHand = 'Right';

  final List<String> _genderOptions = [
    'Masculine',
    'Feminine',
    'Prefer not to say',
  ];
  final List<String> _handOptions = ['Left', 'Right'];

  void _onUseMyLocation() {
    // TODO: Implement location fetching logic
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(
        context,
        RouteName.gamePreferences,
      );
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileCreationAppBar(
              onBackPressed: () => Navigator.pop(context),
              currentStep: 3,
            ),
            24.heightBox,
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('About you', style: AppStyles.w600f18inter),
                      Text(
                        'This helps you find courts and players near you.',
                        style: AppStyles.w400f14inter.copyWith(
                          color: kTextSecondary.withValues(alpha: 0.70),
                        ),
                      ),
                      40.heightBox,
                      Row(
                        children: [
                          Text(
                            'Location',
                            style: AppStyles.w500f14inter.copyWith(
                              color: kTextPrimaryColor,
                            ),
                          ),
                          Spacer(),
                          SvgPicture.asset(Assets.svg.locationIcon.path),
                          2.widthBox,
                          InkWell(
                            onTap: _onUseMyLocation,
                            child: Text(
                              'Use my location',
                              style: AppStyles.w500f14inter.copyWith(
                                color: kBlueColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      6.heightBox,
                      CustomTextField(
                        controller: _locationController,
                        hintText: 'City/area',
                      ),

                      32.heightBox,
                      Text(
                        'Gender',
                        style: AppStyles.w500f14inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                      8.heightBox,
                      Wrap(
                        spacing: getProportionateScreenWidth(8),
                        runSpacing: getProportionateScreenHeight(8),
                        children: _genderOptions.map((gender) {
                          return SelectionButton(
                            label: gender,
                            isSelected: _selectedGender == gender,
                            onTap: () {
                              setState(() {
                                _selectedGender = gender;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      32.heightBox,

                      Text(
                        'Dominant Hand',
                        style: AppStyles.w500f14inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                      8.heightBox,
                      Row(
                        spacing: getProportionateScreenWidth(8),
                        children: _handOptions.map((hand) {
                          return Expanded(
                            child: SelectionButton(
                              label: hand,
                              borderRadius: 16,
                              verticalPadding: 18,
                              isSelected: _selectedHand == hand,
                              onTap: () {
                                setState(() {
                                  _selectedHand = hand;
                                });
                              },
                              icon: hand == "Right"
                                  ? Assets.svg.rightHand.path
                                  : Assets.svg.leftHand.path,
                            ),
                          );
                        }).toList(),
                      ),
                      32.heightBox,
                      CustomActionButton(
                        buttonText: "Continue",
                        onTap: _onContinue,
                        isEnabled: true,
                        backgroundColor: kPrimaryColor,
                        buttonTextColor: kTextPrimaryColor,
                      ),
                      24.heightBox,
                    ],
                  ),
                ).withPaddingSymmetric(24, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
