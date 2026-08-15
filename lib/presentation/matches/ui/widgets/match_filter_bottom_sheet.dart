import 'package:quadraclub_app/presentation/matches/data/match_model.dart';

import '/app_exports.dart';

enum MatchTimeOfDay { morning, afternoon, night }

enum MatchLevelFilter { all, select }

class MatchFilterBottomSheet extends StatefulWidget {
  const MatchFilterBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 680),
      builder: (_) => const MatchFilterBottomSheet(),
    );
  }

  @override
  State<MatchFilterBottomSheet> createState() => _MatchFilterBottomSheetState();
}

class _MatchFilterBottomSheetState extends State<MatchFilterBottomSheet> {
  final Set<MatchTimeOfDay> _selectedTimes = {};
  MatchLevelFilter _level = MatchLevelFilter.all;
  MatchFormat _format = MatchFormat.doubles;
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
                'Game Filters',
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
                  _sectionLabel(label: 'Time of Day'),
                  8.heightBox,
                  Row(
                    spacing: getProportionateScreenWidth(6),
                    children: [
                      TimeChip(
                        label: 'Morning',
                        subtitle: '6h - 12h',
                        isSelected: _selectedTimes.contains(MatchTimeOfDay.morning),
                        onTap: () => _toggleTime(MatchTimeOfDay.morning),
                      ),
                      TimeChip(
                        label: 'Afternoon',
                        subtitle: '12h - 18h',
                        isSelected: _selectedTimes.contains(MatchTimeOfDay.afternoon),
                        onTap: () => _toggleTime(MatchTimeOfDay.afternoon),
                      ),
                      TimeChip(
                        label: 'Night',
                        subtitle: '6 PM - 12 AM',
                        isSelected: _selectedTimes.contains(MatchTimeOfDay.night),
                        onTap: () => _toggleTime(MatchTimeOfDay.night),
                      ),
                    ],
                  ),
                  16.heightBox,
                  _sectionLabel(label: 'Level'),
                  8.heightBox,
                  Row(
                    spacing: getProportionateScreenWidth(6),
                    children: [
                      ToggleChip(
                        label: 'All levels',
                        isSelected: _level == MatchLevelFilter.all,
                        onTap: () => setState(() => _level = MatchLevelFilter.all),
                      ),
                      ToggleChip(
                        label: 'Select Levels',
                        isSelected: _level == MatchLevelFilter.select,
                        onTap: () => setState(() => _level = MatchLevelFilter.select),
                      ),
                    ],
                  ),
                  16.heightBox,
                  _sectionLabel(label: 'Format'),
                  8.heightBox,
                  Row(
                    spacing: getProportionateScreenWidth(6),
                    children: [
                      ToggleChip(
                        label: 'Singles',
                        isSelected: _format == MatchFormat.singles,
                        onTap: () => setState(() => _format = MatchFormat.singles),
                      ),
                      ToggleChip(
                        label: 'Doubles',
                        isSelected: _format == MatchFormat.doubles,
                        onTap: () => setState(() => _format = MatchFormat.doubles),
                      ),
                    ],
                  ),
                  16.heightBox,
                  _sectionLabel(label: 'City'),
                  8.heightBox,
                  CustomTextField(
                    controller: _searchController,
                    hintText: 'Search...',
                    borderRadius: 999,
                  ),
                  8.heightBox,
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
                  _sectionLabel(label: 'Max Distance'),
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

  void _toggleTime(MatchTimeOfDay t) {
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
      _level = MatchLevelFilter.all;
      _format = MatchFormat.doubles;
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
