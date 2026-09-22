import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_filters.dart';

enum FormatFilter { all, group, individual }

class FilterBottomSheet extends StatefulWidget {
  final Set<TimeOfDayFilter> selectedTimes;
  final GenderFilter gender;
  final Set<SportLevel> levels;

  /// Sports to offer level sections for — the header's selection.
  final List<String> sports;
  final FormatFilter format;
  final double distance;
  final String city;

  const FilterBottomSheet({
    super.key,
    this.selectedTimes = const {},
    this.gender = GenderFilter.misto,
    this.levels = const {},
    this.sports = kAllSportSlugs,
    this.format = FormatFilter.group,
    this.distance = 25,
    this.city = '',
  });

  static Future<ClassFilterResult?> show(
    BuildContext context, {
    Set<TimeOfDayFilter> selectedTimes = const {},
    GenderFilter gender = GenderFilter.misto,
    Set<SportLevel> levels = const {},
    List<String> sports = kAllSportSlugs,
    FormatFilter format = FormatFilter.group,
    double distance = 25,
    String city = '',
  }) {
    return showModalBottomSheet<ClassFilterResult>(
      context: context,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxHeight: 680),
      builder: (_) => FilterBottomSheet(
        selectedTimes: selectedTimes,
        gender: gender,
        levels: levels,
        sports: sports,
        format: format,
        distance: distance,
        city: city,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Set<TimeOfDayFilter> _selectedTimes;
  late GenderFilter _gender;
  late Set<SportLevel> _levels;
  late FormatFilter _format;
  late double _distance;

  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _selectedTimes = {...widget.selectedTimes};
    _gender = widget.gender;
    _levels = {...widget.levels};
    _format = widget.format;
    _distance = widget.distance;

    _searchController = TextEditingController(text: widget.city);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: const BorderRadius.only(
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
                l10n.filters,
                style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 22, color: kDarkTextColor),
              ),
            ],
          ).paddingOnly(top: 5, bottom: 21, left: 20, right: 20),

          CommonDivider().withPaddingSymmetric(0, 20),

          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TimeOfDayFilterSection(
                    selected: _selectedTimes,
                    onToggled: _toggleTime,
                  ),

                  24.heightBox,

                  LevelFilterSection(
                    sports: widget.sports,
                    gender: _gender,
                    selected: _levels,
                    onChanged: (gender, levels) => setState(() {
                      _gender = gender;
                      _levels = levels;
                    }),
                  ),

                  24.heightBox,

                  _sectionLabel(label: l10n.format),

                  6.heightBox,

                  Row(
                    spacing: getProportionateScreenWidth(6),
                    children: [
                      ToggleChip(
                        label: l10n.all,
                        isSelected: _format == FormatFilter.all,
                        onTap: () {
                          setState(() {
                            _format = FormatFilter.all;
                          });
                        },
                      ),

                      ToggleChip(
                        label: l10n.group,
                        isSelected: _format == FormatFilter.group,
                        onTap: () {
                          setState(() {
                            _format = FormatFilter.group;
                          });
                        },
                      ),

                      ToggleChip(
                        label: l10n.individual,
                        isSelected: _format == FormatFilter.individual,
                        onTap: () {
                          setState(() {
                            _format = FormatFilter.individual;
                          });
                        },
                      ),
                    ],
                  ),

                  24.heightBox,

                  _sectionLabel(label: l10n.city),

                  6.heightBox,

                  CustomTextField(
                    controller: _searchController,
                    hintText: l10n.search,
                    borderRadius: 999,
                  ),

                  6.heightBox,

                  IntrinsicHeight(
                    child: Row(
                      spacing: getProportionateScreenHeight(6),
                      children: [
                        _buildCityDistanceCard(
                          label: 'New York',
                          distance: '0 km',
                        ),
                        _buildCityDistanceCard(
                          label: 'Los Angeles',
                          distance: '10 km',
                        ),
                        _buildCityDistanceCard(
                          label: 'Chicago',
                          distance: '15 km',
                        ),
                      ],
                    ),
                  ),

                  24.heightBox,

                  _sectionLabel(label: l10n.distance),

                  6.heightBox,

                  DistanceSlider(
                    distance: _distance,
                    onChanged: (value) {
                      setState(() {
                        _distance = value;
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
                    Navigator.pop(
                      context,
                      ClassFilterResult(
                        selectedTimes: {..._selectedTimes},
                        gender: _gender,
                        levels: {..._levels},
                        format: _format,
                        distance: _distance,
                        city: _searchController.text.trim(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ).withPaddingSymmetric(20, 0),
        ],
      ).withPaddingSymmetric(0, 16),
    );
  }

  void _toggleTime(TimeOfDayFilter t) {
    setState(() {
      if (_selectedTimes.contains(t)) {
        _selectedTimes.remove(t);
      } else {
        _selectedTimes.add(t);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedTimes.clear();
      _gender = GenderFilter.misto;
      _levels = {};
      _format = FormatFilter.all;
      _distance = 25;
      _searchController.clear();
    });
  }
}

Widget _sectionLabel({required String label}) {
  return Text(
    label,
    style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
  );
}

Widget _buildCityDistanceCard({
  required String label,
  required String distance,
}) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: kGreyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: getProportionateScreenHeight(6),
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppStyles.w500f12inter.copyWith(color: kDarkTextColor),
          ),
          Text(
            distance,
            style: AppStyles.w400f12inter.copyWith(color: kDarkTextColor),
          ),
        ],
      ).withPaddingSymmetric(8, 8),
    ),
  );
}
