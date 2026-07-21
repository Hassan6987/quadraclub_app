import 'package:quadraclub_app/presentation/common/widgets/common_chip.dart';
import 'package:quadraclub_app/presentation/matches/data/dummy_match_data.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_card.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_join_bottom_sheet.dart';
import '/app_exports.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  SportType? _selectedSport;
  DateTime _selectedDate = DateTime(2025, 4, 1);
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';

  List<DateTime> get _dates =>
      List.generate(7, (i) => DateTime(2025, 4, 1).add(Duration(days: i)));

  List<MatchModel> get _filtered {
    return dummyMatches.where((m) {
      final matchesSport = _selectedSport == null || m.sport == _selectedSport;
      final matchesSearch =
          _searchQuery.isEmpty ||
          m.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.city.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSport && matchesSearch;
    }).toList();
  }

  Map<String, List<MatchModel>> get _groupedMatches {
    const demoToday = 7;

    final result = <String, List<MatchModel>>{};
    for (final m in _filtered) {
      String label;
      if (m.date.day == demoToday && m.date.month == 4) {
        label = 'Today, ${m.date.day} Apr';
      } else if (m.date.day == demoToday + 1 && m.date.month == 4) {
        label = 'Tomorrow, ${m.date.day} Apr';
      } else {
        label = '${m.date.day} Apr';
      }
      result.putIfAbsent(label, () => []).add(m);
    }
    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedMatches;

    return Scaffold(
      backgroundColor: kCardColor,
      appBar: AppBar(
        backgroundColor: kCardColor,
        elevation: 0,
        title: Text(
          "Join open matches.",
          style: AppStyles.w600f24inter.copyWith(
            color: kDarkTextColor,
            fontSize: 22,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: SvgPicture.asset(
              Assets.svg.calendarBlank.path,
              height: 24,
              width: 24,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                SvgPicture.asset(
                  Assets.svg.notification.path,
                  height: 24,
                  width: 24,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: kRedColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kWhiteColor,
              border: Border(bottom: BorderSide(color: kBorderColor)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final sport in SportType.values) ...[
                        CommonChip(
                          label: sport.label,
                          isSelected: _selectedSport == sport,
                          onTap: () => setState(() {
                            _selectedSport = _selectedSport == sport
                                ? null
                                : sport;
                          }),
                        ).paddingOnly(
                          right: sport.index == SportType.values.length - 1
                              ? 0
                              : 6,
                        ),
                      ],
                    ],
                  ),
                ).withPaddingSymmetric(16, 0),
                12.heightBox,
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _searchController,
                        hintText: "Search...",
                        borderRadius: 100,
                      ),
                    ),
                    8.widthBox,
                    GestureDetector(
                      onTap: () => MatchFilterBottomSheet.show(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: kBorderColor),
                        ),
                        child: SvgPicture.asset(
                          Assets.svg.filterLines.path,
                        ).withPaddingAll(8),
                      ),
                    ),
                    8.widthBox,
                    GestureDetector(
                      onTap: () {
                        // TODO: Show map view
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: kBorderColor),
                        ),
                        child: SvgPicture.asset(
                          Assets.svg.mapMarker.path,
                        ).withPaddingAll(8),
                      ),
                    ),
                  ],
                ).withPaddingSymmetric(16, 0),
                12.heightBox,
                CommonDateSelectionRow(
                  dates: _dates,
                  selectedDate: _selectedDate,
                  onDateSelected: (d) => setState(() => _selectedDate = d),
                ).paddingOnly(left: 16),
                16.heightBox,
              ],
            ),
          ),
          Expanded(
            child: grouped.isEmpty
                ? Center(
                    child: Text(
                      'No matches found.',
                      style: AppStyles.w600f18inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      for (final entry in grouped.entries) ...[
                        _dateGroupHeader(label: entry.key),
                        for (final match in entry.value)
                          MatchCard(
                            match: match,
                            onTap: () => _openJoinMatch(match),
                          ),
                      ],
                    ],
                  ),
          ),
        ],
      ).withPaddingSymmetric(0, 12),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: kBlackColor,
          shape: BoxShape.circle,
        ),
        child: GestureDetector(
          onTap: () {
            // TODO: Create new match
          },
          child: Icon(
            Icons.add,
            color: kWhiteColor,
            size: 32,
          ),
        ),
      ),
    );
  }

  void _openJoinMatch(MatchModel match) {
    MatchJoinBottomSheet.show(context, match);
  }

  Widget _dateGroupHeader({required String label}) {
    return Row(
      children: [
        SvgPicture.asset(Assets.svg.calendarBlank.path),
        4.widthBox,
        Text(
          label,
          style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
        ),
        6.widthBox,
        Expanded(child: Divider(color: kTextColor.withValues(alpha: 0.50))),
      ],
    ).withPaddingSymmetric(16, 12);
  }
}
