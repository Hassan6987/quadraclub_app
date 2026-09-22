import '/app_exports.dart';

/// Multi-select "Time of Day" section. Identical on Courts, Matches and
/// Classes, including the am/pm ranges.
class TimeOfDayFilterSection extends StatelessWidget {
  final Set<TimeOfDayFilter> selected;
  final ValueChanged<TimeOfDayFilter> onToggled;

  const TimeOfDayFilterSection({
    super.key,
    required this.selected,
    required this.onToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionLabel(label: AppLocalizations.of(context)!.timeOfDay),

        8.heightBox,

        Row(
          children: [
            for (final time in TimeOfDayFilter.values) ...[
              if (time != TimeOfDayFilter.values.first) const SizedBox(width: 6),
              Expanded(
                child: _TimeCard(
                  label: time.label(context),
                  range: time.range(context),
                  isSelected: selected.contains(time),
                  onTap: () => onToggled(time),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String label;
  final String range;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeCard({
    required this.label,
    required this.range,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : kGreyColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: kBorderColor),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: AppStyles.w500f12inter.copyWith(color: kDarkTextColor),
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                range,
                maxLines: 1,
                style: AppStyles.w400f12inter.copyWith(color: kTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Level" section: narrows by sport, then gender, then level.
///
/// Each sport in [sports] gets a collapsible section and only one is open at
/// a time. The gender toggle above them decides which groups those sections
/// show; "Misto" imposes no restriction and shows both.
///
/// An empty [selected] set means "all levels".
class LevelFilterSection extends StatefulWidget {
  /// Sport slugs to offer, normally whatever the header has selected.
  final List<String> sports;
  final GenderFilter gender;
  final Set<SportLevel> selected;
  final void Function(GenderFilter gender, Set<SportLevel> levels) onChanged;

  const LevelFilterSection({
    super.key,
    required this.sports,
    required this.gender,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<LevelFilterSection> createState() => _LevelFilterSectionState();
}

class _LevelFilterSectionState extends State<LevelFilterSection> {
  String? _openSport;

  void _selectGender(GenderFilter gender) {
    // Switching away from Misto drops anything picked in the group that is
    // about to disappear.
    widget.onChanged(gender, levelsAllowedBy(widget.selected, gender));
  }

  void _toggleLevel(SportLevel level) {
    final next = {...widget.selected};

    if (!next.remove(level)) next.add(level);

    widget.onChanged(widget.gender, next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final sports = widget.sports
        .where((s) => levelsForSport(s).isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionLabel(label: l10n.level),

        8.heightBox,

        Row(
          spacing: getProportionateScreenWidth(6),
          children: [
            for (final gender in [
              GenderFilter.homem,
              GenderFilter.mulher,
              GenderFilter.misto,
            ])
              ToggleChip(
                label: gender.label(context),
                isSelected: widget.gender == gender,
                onTap: () => _selectGender(gender),
              ),
          ],
        ),

        8.heightBox,

        for (final sport in sports)
          _SportLevelSection(
            sport: sport,
            groups: widget.gender.visibleGroups,
            selected: widget.selected,
            isOpen: _openSport == sport,
            onHeaderTap: () =>
                setState(() => _openSport = _openSport == sport ? null : sport),
            onLevelTapped: _toggleLevel,
          ),
      ],
    );
  }
}

class _SportLevelSection extends StatelessWidget {
  final String sport;
  final List<LevelGroup> groups;
  final Set<SportLevel> selected;
  final bool isOpen;
  final VoidCallback onHeaderTap;
  final ValueChanged<SportLevel> onLevelTapped;

  const _SportLevelSection({
    required this.sport,
    required this.groups,
    required this.selected,
    required this.isOpen,
    required this.onHeaderTap,
    required this.onLevelTapped,
  });

  @override
  Widget build(BuildContext context) {
    final levels = levelsForSport(sport);

    final selectedHere = selected.where((s) => s.sport == sport).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onHeaderTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      localizedSportName(context, sport),
                      style: AppStyles.w500f14inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                  ),

                  if (selectedHere > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '$selectedHere',
                        style: AppStyles.w500f12inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: kTextColor,
                  ),
                ],
              ),
            ),
          ),

          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final group in groups) ...[
                    // With one group visible the toggle above already says
                    // which it is, so the heading would just repeat it.
                    if (groups.length > 1) ...[
                      Text(
                        group.label(context),
                        style: AppStyles.w400f12inter.copyWith(
                          color: kTextColor,
                        ),
                      ),
                      6.heightBox,
                    ],

                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final level in levels)
                          ToggleChip(
                            label: localizedLevelName(context, level),
                            isSelected: selected.contains(
                              SportLevel(
                                sport: sport,
                                group: group,
                                level: level,
                              ),
                            ),
                            onTap: () => onLevelTapped(
                              SportLevel(
                                sport: sport,
                                group: group,
                                level: level,
                              ),
                            ),
                          ),
                      ],
                    ),

                    if (group != groups.last) 12.heightBox,
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class FilterSectionLabel extends StatelessWidget {
  final String label;

  const FilterSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
    );
  }
}
