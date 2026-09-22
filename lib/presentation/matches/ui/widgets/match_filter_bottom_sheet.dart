import 'package:quadraclub_app/presentation/matches/data/match_model.dart';

import '/app_exports.dart';

class MatchFilterBottomSheet extends StatefulWidget {
  final Set<TimeOfDayFilter> initialTimes;
  final GenderFilter initialGender;
  final Set<SportLevel> initialLevels;

  /// Sports to offer level sections for — the header's selection.
  final List<String> sports;
  final String? initialCity;
  final double? initialDistance;
  final MatchFormat? initialFormat;
  final List<String> availableCities;
  final void Function(
    Set<TimeOfDayFilter> times,
    GenderFilter gender,
    Set<SportLevel> levels,
    String? city,
    double? distance,
    MatchFormat? format,
  )
  onApply;

  const MatchFilterBottomSheet({
    super.key,
    this.initialTimes = const {},
    this.initialGender = GenderFilter.misto,
    this.initialLevels = const {},
    this.sports = kAllSportSlugs,
    this.initialCity,
    this.initialDistance,
    this.initialFormat,
    this.availableCities = const [],
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    Set<TimeOfDayFilter> initialTimes = const {},
    GenderFilter initialGender = GenderFilter.misto,
    Set<SportLevel> initialLevels = const {},
    List<String> sports = kAllSportSlugs,
    String? initialCity,
    double? initialDistance,
    MatchFormat? initialFormat,
    List<String> availableCities = const [],
    required void Function(
      Set<TimeOfDayFilter> times,
      GenderFilter gender,
      Set<SportLevel> levels,
      String? city,
      double? distance,
      MatchFormat? format,
    )
    onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 680),
      builder: (_) => MatchFilterBottomSheet(
        initialTimes: initialTimes,
        initialGender: initialGender,
        initialLevels: initialLevels,
        sports: sports,
        initialCity: initialCity,
        initialDistance: initialDistance,
        initialFormat: initialFormat,
        availableCities: availableCities,
        onApply: onApply,
      ),
    );
  }

  @override
  State<MatchFilterBottomSheet> createState() => _MatchFilterBottomSheetState();
}

class _MatchFilterBottomSheetState extends State<MatchFilterBottomSheet> {
  final Set<TimeOfDayFilter> _times = {};
  GenderFilter _gender = GenderFilter.misto;
  Set<SportLevel> _levels = {};
  MatchFormat? _format;
  String? _selectedCity;
  double _distance = 25;
  bool _enableDistance = false;
  final TextEditingController _searchController = TextEditingController();

  List<String> get _quickCities {
    if (widget.availableCities.isNotEmpty)
      return widget.availableCities.take(3).toList();
    return const ['New York', 'Los Angeles', 'Chicago'];
  }

  @override
  void initState() {
    super.initState();
    _times.addAll(widget.initialTimes);
    _gender = widget.initialGender;
    _levels = {...widget.initialLevels};
    _format = widget.initialFormat;
    _selectedCity = widget.initialCity;
    if (widget.initialDistance != null) {
      _distance = widget.initialDistance!;
      _enableDistance = true;
    }
    if (_selectedCity != null) {
      _searchController.text = _selectedCity!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _times.clear();
      _gender = GenderFilter.misto;
      _levels = {};
      _format = null;
      _selectedCity = null;
      _distance = 25;
      _enableDistance = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                l10n.gameFilters,
                style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 22, color: kDarkTextColor),
              ),
            ],
          ).paddingOnly(top: 5, bottom: 21, left: 20, right: 20),
          CommonDivider(),
          20.heightBox,
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TimeOfDayFilterSection(
                    selected: _times,
                    onToggled: (time) => setState(() {
                      if (!_times.remove(time)) _times.add(time);
                    }),
                  ),
                  16.heightBox,
                  LevelFilterSection(
                    sports: widget.sports,
                    gender: _gender,
                    selected: _levels,
                    onChanged: (gender, levels) => setState(() {
                      _gender = gender;
                      _levels = levels;
                    }),
                  ),
                  16.heightBox,
                  _sectionLabel(label: l10n.format),
                  8.heightBox,
                  Row(
                    spacing: getProportionateScreenWidth(6),
                    children: [
                      ToggleChip(
                        label: l10n.allFormats,
                        isSelected: _format == null,
                        onTap: () => setState(() => _format = null),
                      ),
                      ToggleChip(
                        label: l10n.singles,
                        isSelected: _format == MatchFormat.singles,
                        onTap: () =>
                            setState(() => _format = MatchFormat.singles),
                      ),
                      ToggleChip(
                        label: l10n.doubles,
                        isSelected: _format == MatchFormat.doubles,
                        onTap: () =>
                            setState(() => _format = MatchFormat.doubles),
                      ),
                    ],
                  ),
                  16.heightBox,
                  _sectionLabel(label: l10n.city),
                  8.heightBox,
                  CustomTextField(
                    controller: _searchController,
                    hintText: l10n.search,
                    borderRadius: 999,
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value.trim().isEmpty
                            ? null
                            : value.trim();
                      });
                    },
                  ),
                  8.heightBox,
                  IntrinsicHeight(
                    child: Row(
                      spacing: getProportionateScreenHeight(6),
                      children: _quickCities.map((city) {
                        final isSelected =
                            (_selectedCity ?? '').toLowerCase() ==
                            city.toLowerCase();
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedCity = null;
                                  _searchController.clear();
                                } else {
                                  _selectedCity = city;
                                  _searchController.text = city;
                                }
                              });
                            },
                            child: _buildCityCard(
                              label: city,
                              isSelected: isSelected,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  24.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionLabel(label: l10n.maxDistance),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _enableDistance = !_enableDistance),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _enableDistance ? kPrimaryColor : kGreyColor,
                            borderRadius: BorderRadius.circular(12),
                            border: _enableDistance
                                ? null
                                : Border.all(color: kBorderColor),
                          ),
                          child: Text(
                            _enableDistance
                                ? l10n.withinDistance(_distance.round())
                                : l10n.anyDistance,
                            style: AppStyles.w500f12inter.copyWith(
                              color: kDarkTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  6.heightBox,
                  DistanceSlider(
                    distance: _distance,
                    onChanged: (value) {
                      setState(() {
                        _distance = value;
                        _enableDistance = true;
                      });
                    },
                  ),
                ],
              ).withPaddingSymmetric(20, 0),
            ),
          ),
          32.heightBox,
          CommonDivider(),
          16.heightBox,
          Row(
            children: [
              Expanded(
                child: CustomActionButton(
                  onTap: _clearFilters,
                  buttonText: l10n.clearFilters,
                  backgroundColor: kWhiteColor,
                  borderColor: kBorderColor,
                  isEnabled: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomActionButton(
                  buttonText: l10n.showResults,
                  onTap: () {
                    widget.onApply(
                      {..._times},
                      _gender,
                      {..._levels},
                      _selectedCity,
                      _enableDistance ? _distance : null,
                      _format,
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ).withPaddingSymmetric(20, 0),
        ],
      ).withPaddingSymmetric(0, 16),
    );
  }
}

Widget _sectionLabel({required String label}) =>
    FilterSectionLabel(label: label);

Widget _buildCityCard({required String label, required bool isSelected}) {
  return Container(
    decoration: BoxDecoration(
      color: isSelected ? kPrimaryColor.withValues(alpha: 0.2) : kGreyColor,
      borderRadius: BorderRadius.circular(12),
      border: isSelected ? Border.all(color: kPrimaryColor) : null,
    ),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: AppStyles.w500f12inter.copyWith(color: kDarkTextColor),
    ).withPaddingSymmetric(8, 8),
  );
}
