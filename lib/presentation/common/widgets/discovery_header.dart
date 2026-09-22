import '/app_exports.dart';

/// Shared metrics so the Courts / Matches / Classes headers are pixel
/// identical. Change them here, not in the screens.
const double kHeaderHorizontalPadding = 16;
const double kSportPillHeight = 30;
const double kHeaderControlHeight = 38;
const double kHeaderRowGap = 10;

/// Fixed (non scrollable) row of sport pills.
///
/// Every sport is always visible: the row divides the available width
/// between the pills instead of scrolling horizontally.
class SportFilterRow extends StatelessWidget {
  final List<String> sports;
  final Set<String> selectedSports;
  final ValueChanged<String> onSportToggled;

  /// Inset of the row itself. Pass 0 when it already sits inside a padded
  /// parent so the pills keep the same size everywhere.
  final double horizontalPadding;

  const SportFilterRow({
    super.key,
    required this.selectedSports,
    required this.onSportToggled,
    this.sports = kAllSportSlugs,
    this.horizontalPadding = kHeaderHorizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SizedBox(
        height: kSportPillHeight,
        child: Row(
          children: [
            for (var i = 0; i < sports.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              // Width is shared proportionally to the label so "Beach
              // Tennis" gets more room than "Padel".
              Expanded(
                flex: localizedSportName(context, sports[i]).length.clamp(1, 40),
                child: _SportPill(
                  label: localizedSportName(context, sports[i]),
                  isSelected: selectedSports.contains(sports[i]),
                  onTap: () => onSportToggled(sports[i]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SportPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SportPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kSportPillHeight,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : kGreyColor,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? null : Border.all(color: kBorderColor),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: AppStyles.w400f14inter.copyWith(color: kDarkTextColor),
          ),
        ),
      ),
    );
  }
}

/// Round 38x38 action button used for the filter and map controls.
class HeaderIconButton extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final VoidCallback onTap;

  const HeaderIconButton({
    super.key,
    required this.child,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: kHeaderControlHeight,
        height: kHeaderControlHeight,
        decoration: BoxDecoration(
          color: isActive ? kPrimaryColor : kWhiteColor,
          shape: BoxShape.circle,
          border: Border.all(color: kBorderColor),
        ),
        child: Center(child: child),
      ),
    );
  }
}

/// Compact live-search field. Typing filters the list underneath in
/// real time — no modal, on any screen.
class HeaderSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const HeaderSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kHeaderControlHeight,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: kDarkTextColor,
        style: AppStyles.w400f14inter.copyWith(color: kTextPrimaryColor),
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: kWhiteColor,
          hintText: hintText,
          hintStyle: AppStyles.w400f14inter.copyWith(
            color: kTextSecondary.withValues(alpha: 0.50),
          ),
          prefixIcon: const Icon(Icons.search, size: 18, color: kDarkTextColor),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 34,
            minHeight: kHeaderControlHeight,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          border: _border(kBorderColor),
          enabledBorder: _border(kBorderColor),
          focusedBorder: _border(kDarkTextColor),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(100),
    borderSide: BorderSide(color: color),
  );
}

/// The white header shared by Courts, Matches and Classes: sport pills,
/// search + filter + map row, optional active-filter badges and the date
/// strip. The screens only differ in their title (on [CustomAppBar]) and
/// in which modal [onFilterTap] opens.
class DiscoveryHeader extends StatelessWidget {
  final Set<String> selectedSports;
  final ValueChanged<String> onSportToggled;

  final TextEditingController searchController;
  final String searchHint;
  final ValueChanged<String> onSearchChanged;

  final VoidCallback onFilterTap;
  final bool hasActiveFilters;
  final VoidCallback onMapTap;

  /// Pills describing the filters currently applied, plus a "clear all"
  /// affordance. Rendered between the search row and the date strip.
  final List<Widget> activeFilterBadges;

  final List<DateTime> dates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DiscoveryHeader({
    super.key,
    required this.selectedSports,
    required this.onSportToggled,
    required this.searchController,
    required this.searchHint,
    required this.onSearchChanged,
    required this.onFilterTap,
    required this.onMapTap,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
    this.hasActiveFilters = false,
    this.activeFilterBadges = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhiteColor,
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),

          SportFilterRow(
            selectedSports: selectedSports,
            onSportToggled: onSportToggled,
          ),

          const SizedBox(height: kHeaderRowGap),

          Row(
            children: [
              Expanded(
                child: HeaderSearchField(
                  controller: searchController,
                  hintText: searchHint,
                  onChanged: onSearchChanged,
                ),
              ),

              8.widthBox,

              HeaderIconButton(
                isActive: hasActiveFilters,
                onTap: onFilterTap,
                child: SvgPicture.asset(
                  Assets.svg.filterLines.path,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    kDarkTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              8.widthBox,

              HeaderIconButton(
                onTap: onMapTap,
                child: const Icon(
                  Icons.map_outlined,
                  size: 20,
                  color: kDarkTextColor,
                ),
              ),
            ],
          ).withPaddingSymmetric(kHeaderHorizontalPadding, 0),

          if (activeFilterBadges.isNotEmpty) ...[
            8.heightBox,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: kHeaderHorizontalPadding,
              ),
              child: Row(children: activeFilterBadges),
            ),
          ],

          const SizedBox(height: kHeaderRowGap),

          CommonDateSelectionRow(
            dates: dates,
            selectedDate: selectedDate,
            onDateSelected: onDateSelected,
          ),

          12.heightBox,
        ],
      ),
    );
  }
}

/// Pill describing one applied filter, with an inline clear button.
class HeaderFilterBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onClear;

  const HeaderFilterBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: kPrimaryColor.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPrimaryColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: kDarkTextColor),
          4.widthBox,
          Text(
            label,
            style: AppStyles.w500f12inter.copyWith(color: kDarkTextColor),
          ),
          4.widthBox,
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, size: 14, color: kDarkTextColor),
          ),
        ],
      ),
    );
  }
}

/// "Clear all" text action that closes out the badge row.
class HeaderClearAllButton extends StatelessWidget {
  final VoidCallback onTap;

  const HeaderClearAllButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        AppLocalizations.of(context)!.clearAll,
        style: AppStyles.w500f12inter.copyWith(
          color: kDarkTextColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
