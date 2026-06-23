import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/widgets/profile_creation_app_bar.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/widgets/selection_button.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

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
      // Navigate to next step
      // TODO: Implement navigation
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


                      Text(
                        'About you',
                        style: AppStyles.w600f18inter,

                      ),
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
                          ),Spacer(),
                          SvgPicture.asset(Assets.svg.locationIcon.path),
                          2.widthBox,
                          InkWell(
                            onTap: _onUseMyLocation,
                            child: Text(
                              'Use my location',
                              style: AppStyles.w500f14inter.copyWith(
                                color:kBlueColor
                              ),
                            ),
                          ),
                        ],
                      ),
                      8.heightBox,
                      CustomTextField(
                        controller: _locationController,
                        hintText: 'City/area',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your location';
                          }
                          return null;
                        },
                      ),

                      32.heightBox,
                      Text(
                        'Gender',
                        style: AppStyles.w500f14inter.copyWith(
                          color: kDarkColor,
                        ),
                      ),
                      8.heightBox,
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
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
                      24.heightBox,
                      Text(
                        'Dominant Hand',
                        style: AppStyles.w500f14inter.copyWith(
                          color: kTextPrimaryColor,
                        ),
                      ),
                      12.heightBox,
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _handOptions.map((hand) {
                          return SelectionButton(
                            label: hand,
                            isSelected: _selectedHand == hand,
                            onTap: () {
                              setState(() {
                                _selectedHand = hand;
                              });
                            },
                            icon: Icon(
                              hand == 'Left' ? Icons.back_hand : Icons.front_hand,
                              size: 20,
                              color: _selectedHand == hand
                                  ? kWhiteColor
                                  : kTextPrimaryColor,
                            ),
                          );
                        }).toList(),
                      ),
                      32.heightBox,
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF01386C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Continue',
                            style: AppStyles.w500f16inter.copyWith(
                              color: kWhiteColor,
                            ),
                          ),
                        ),
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
