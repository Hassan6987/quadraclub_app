import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/data/model/signup_data.dart';
import 'package:quadraclub_app/presentation/authentication/ui/signup/confirmation_screen.dart';
import 'package:quadraclub_app/presentation/authentication/ui/signup/onboarding_app_bar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import '/app_exports.dart';

/// Step 5/5.
class DefineLevelScreen extends StatefulWidget {
  final SignupData data;

  const DefineLevelScreen({super.key, required this.data});

  @override
  State<DefineLevelScreen> createState() => _DefineLevelScreenState();
}

class _CategoryOption {
  final String label;
  final String description;

  const _CategoryOption(this.label, this.description);
}

class _DefineLevelScreenState extends State<DefineLevelScreen> {
  static const _categoryOptions = <_CategoryOption>[
    _CategoryOption('Open', 'For advanced/competitive players'),
    _CategoryOption('Category 1', 'Beginner level players'),
    _CategoryOption('Category 2', 'Intermediate level players'),
    _CategoryOption('Category 3', 'Advanced level players'),
  ];

  static const _sportIcons = {
    'Padel': Icons.sports_tennis_outlined,
    'Tennis': Icons.sports_tennis,
    'Beach Tennis': Icons.beach_access_outlined,
    'Pickleball': Icons.sports_baseball_outlined,
  };

  String? _preferredSide;
  String? _openDropdownSport;

  bool get _isButtonEnabled =>
      _preferredSide != null &&
      widget.data.selectedSports.every(
        (s) => widget.data.sportCategories[s] != null,
      );

  void _selectCategory(String sport, String category) {
    setState(() {
      widget.data.sportCategories[sport] = category;
      _openDropdownSport = null;
    });
  }

  void _onComplete() {
    if (!_isButtonEnabled) return;
    widget.data.preferredSide = _preferredSide;
    context.read<AuthBloc>().add(SetupProfile(data: widget.data));
  }

  Widget _sportCategoryField(String sport) {
    final selected = widget.data.sportCategories[sport];
    final isOpen = _openDropdownSport == sport;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _sportIcons[sport] ?? Icons.sports_outlined,
                size: 18,
                color: kTextColor,
              ),
              8.widthBox,
              Text(
                sport,
                style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
              ),
              4.widthBox,
              Tooltip(
                message: "You can change this later",
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(Icons.info_outline, size: 14, color: kTextColor),
              ),
            ],
          ),
          8.heightBox,
          GestureDetector(
            onTap: () =>
                setState(() => _openDropdownSport = isOpen ? null : sport),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: kBorderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selected ?? "Select your category",
                    style: AppStyles.subtitleRegular.copyWith(
                      color: selected == null ? kTextColor : kBlackColor,
                    ),
                  ),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                border: Border.all(color: kBorderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _categoryOptions.map((option) {
                  final isSelected = selected == option.label;
                  return InkWell(
                    onTap: () => _selectCategory(sport, option.label),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFC5E028)
                            : kWhiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Text(
                            option.label,
                            style: AppStyles.subtitleRegular.copyWith(
                              color: kBlackColor,
                            ),
                          ),
                          4.widthBox,
                          Tooltip(
                            message: option.description,
                            triggerMode: TooltipTriggerMode.tap,
                            child: Icon(
                              Icons.info_outline,
                              size: 14,
                              color: kTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _preferredSideField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Preferred Side",
            style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
          ),
          12.heightBox,
          Row(
            children: ['Left', 'Right', 'Both'].map((side) {
              final isSelected = _preferredSide == side;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _preferredSide = side),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF3FBCB) : kWhiteColor,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFC5E028)
                            : kBorderColor,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      side,
                      textAlign: TextAlign.center,
                      style: AppStyles.subtitleMedium.copyWith(
                        color: kBlackColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sports = widget.data.selectedSports;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.success) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => ConfirmationScreen(data: widget.data)),
                (route) => false,
          );
        } else if (state.status == AuthStateStatus.failure) {
          context.showToast(state.error ?? "Something Went Wrong");
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kWhiteColor,
          appBar: const OnboardingAppBar(currentStep: 5, totalSteps: 5),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dim.PADDING_SIZE_LARGE),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.heightBox,
                Text(
                  "Define your level.",
                  style: AppStyles.subHeadingSemibold.copyWith(
                    color: kBlackColor,
                  ),
                ),
                Text(
                  "Select your category for each sport. You can change it later.",
                  style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
                ),
                24.heightBox,
                for (int i = 0; i < sports.length; i++) ...[
                  _sportCategoryField(sports[i]),
                  if (i == 0) _preferredSideField(),
                ],
                if(state.status == AuthStateStatus.loading)
                  Center(child: CustomLoadingView()),
                if(state.status != AuthStateStatus.loading)
                  CustomActionButton(
                    buttonText: "Complete Registration",
                    onTap: _onComplete,
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
      },
    );
  }
}
