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
  /// English value used internally and sent to the API.
  final String value;

  /// English description used internally.
  final String description;

  const _CategoryOption(this.value, this.description);
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
      // Keep the English value for the API.
      widget.data.sportCategories[sport] = category;
      _openDropdownSport = null;
    });
  }

  void _onComplete() {
    if (!_isButtonEnabled) return;

    // Keep the English value for the API.
    widget.data.preferredSide = _preferredSide;

    context.read<AuthBloc>().add(SetupProfile(data: widget.data));
  }

  String _getCategoryLabel(AppLocalizations l10n, String category) {
    switch (category) {
      case 'Open':
        return l10n.categoryOpen;

      case 'Category 1':
        return l10n.category1;

      case 'Category 2':
        return l10n.category2;

      case 'Category 3':
        return l10n.category3;

      default:
        return category;
    }
  }

  String _getCategoryDescription(AppLocalizations l10n, String category) {
    switch (category) {
      case 'Open':
        return l10n.categoryOpenDescription;

      case 'Category 1':
        return l10n.category1Description;

      case 'Category 2':
        return l10n.category2Description;

      case 'Category 3':
        return l10n.category3Description;

      default:
        return category;
    }
  }

  String _getPreferredSideLabel(AppLocalizations l10n, String side) {
    switch (side) {
      case 'Left':
        return l10n.left;

      case 'Right':
        return l10n.right;

      case 'Both':
        return l10n.both;

      default:
        return side;
    }
  }

  Widget _sportCategoryField(String sport, AppLocalizations l10n) {
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
                message: l10n.youCanChangeThisLater,
                triggerMode: TooltipTriggerMode.tap,
                child: const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: kTextColor,
                ),
              ),
            ],
          ),
          8.heightBox,
          GestureDetector(
            onTap: () {
              setState(() {
                _openDropdownSport = isOpen ? null : sport;
              });
            },
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
                    selected == null
                        ? l10n.selectYourCategory
                        : _getCategoryLabel(l10n, selected),
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
                  final isSelected = selected == option.value;

                  return InkWell(
                    onTap: () => _selectCategory(sport, option.value),
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
                            _getCategoryLabel(l10n, option.value),
                            style: AppStyles.subtitleRegular.copyWith(
                              color: kBlackColor,
                            ),
                          ),
                          4.widthBox,
                          Tooltip(
                            message: _getCategoryDescription(
                              l10n,
                              option.value,
                            ),
                            triggerMode: TooltipTriggerMode.tap,
                            child: const Icon(
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

  Widget _preferredSideField(AppLocalizations l10n) {
    const sides = ['Left', 'Right', 'Both'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.preferredSide,
            style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
          ),
          12.heightBox,
          Row(
            children: sides.map((side) {
              final isSelected = _preferredSide == side;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      // Keep the English value internally.
                      _preferredSide = side;
                    });
                  },
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
                      _getPreferredSideLabel(l10n, side),
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
    final l10n = AppLocalizations.of(context)!;
    final sports = widget.data.selectedSports;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.success) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => ConfirmationScreen(data: widget.data),
            ),
            (route) => false,
          );
        } else if (state.status == AuthStateStatus.failure) {
          context.showToast(state.error ?? l10n.somethingWentWrong);
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
                  l10n.defineYourLevel,
                  style: AppStyles.subHeadingSemibold.copyWith(
                    color: kBlackColor,
                  ),
                ),

                Text(
                  l10n.selectCategoryForEachSport,
                  style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
                ),

                24.heightBox,

                for (int i = 0; i < sports.length; i++) ...[
                  _sportCategoryField(sports[i], l10n),

                  if (i == 0) _preferredSideField(l10n),
                ],

                if (state.status == AuthStateStatus.loading)
                  Center(child: CustomLoadingView()),

                if (state.status != AuthStateStatus.loading)
                  CustomActionButton(
                    buttonText: l10n.completeRegistration,
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
