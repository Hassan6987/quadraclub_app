import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/utils/components/common_divider.dart';

enum TimeOfDay { morning, afternoon, night }

enum LevelFilter { all, select }

enum FormatFilter { group, individual }

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 680),

      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final Set<TimeOfDay> _selectedTimes = {};
  LevelFilter _level = LevelFilter.all;
  FormatFilter _format = FormatFilter.group;
  double _distance = 25;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                'Filters',
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
                  _sectionLabel(label: 'Time of Day'),
                  6.heightBox,
                  Row(
                    spacing: getProportionateScreenWidth(6),
                    children: [
                      TimeChip(
                        label: 'Morning',
                        subtitle: '6h - 12h',
                        isSelected: _selectedTimes.contains(TimeOfDay.morning),
                        onTap: () => _toggleTime(TimeOfDay.morning),
                      ),

                      TimeChip(
                        label: 'Afternoon',
                        subtitle: '12h - 18h',
                        isSelected: _selectedTimes.contains(
                          TimeOfDay.afternoon,
                        ),
                        onTap: () => _toggleTime(TimeOfDay.afternoon),
                      ),

                      TimeChip(
                        label: 'Night',
                        subtitle: '6 PM - 12 AM',
                        isSelected: _selectedTimes.contains(TimeOfDay.night),
                        onTap: () => _toggleTime(TimeOfDay.night),
                      ),
                    ],
                  ),
                  24.heightBox,
                  _sectionLabel(label: 'Level'),
                  6.heightBox,
                  Row(
                    spacing: getProportionateScreenWidth(6),
                    children: [
                      ToggleChip(
                        label: 'All levels',
                        isSelected: _level == LevelFilter.all,
                        onTap: () => setState(() => _level = LevelFilter.all),
                      ),
                      ToggleChip(
                        label: 'Select Levels',
                        isSelected: _level == LevelFilter.select,
                        onTap: () =>
                            setState(() => _level = LevelFilter.select),
                      ),
                    ],
                  ),
                  24.heightBox,
                  _sectionLabel(label: 'Format'),
                  6.heightBox,
                  Row(
                    spacing: getProportionateScreenWidth(6),
                    children: [
                      ToggleChip(
                        label: 'Group',
                        isSelected: _format == FormatFilter.group,
                        onTap: () =>
                            setState(() => _format = FormatFilter.group),
                      ),

                      ToggleChip(
                        label: 'Individual',
                        isSelected: _format == FormatFilter.individual,
                        onTap: () =>
                            setState(() => _format = FormatFilter.individual),
                      ),
                    ],
                  ),
                  24.heightBox,
                  _sectionLabel(label: 'City'),
                  6.heightBox,
                  CustomTextField(
                    controller: _searchController,
                    hintText: 'Search..',
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
                  _sectionLabel(label: 'Distance'),
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
                  buttonText: "Clear Filters",
                  backgroundColor: kWhiteColor,
                  borderColor: kBorderColor,
                  isEnabled: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomActionButton(
                  buttonText: "Show Results",
                  onTap: () {
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

  void _toggleTime(TimeOfDay t) {
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
      _level = LevelFilter.all;
      _format = FormatFilter.group;
      _distance = 25;
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
