import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadraclub_app/presentation/common/widgets/common_chip.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_map_view.dart';
import 'package:quadraclub_app/presentation/matches/data/dummy_match_data.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/create_match_dialog.dart';
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
  bool _isMapView = false;
  String _currentLocation = 'London, UK';
  LatLng _currentLatLng = const LatLng(51.5072, -0.1276);
  SportType? _selectedSport;
  DateTime _selectedDate = DateTime(2025, 4, 1);
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';

  String? _filterTimeOfDay;
  String? _filterCity;
  double _filterDistance = 25.0;

  final Set<String> _selectedSports = {};
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
    if (_isMapView) {
      return CourtMapView(
        courts: context.read<CourtsState>().courts,
        currentLocation: _currentLocation,
        initialCenter: _currentLatLng,
        onLocationChanged: (LocationResult location) {
          setState(() {
            _currentLocation = location.address;
            _currentLatLng = LatLng(location.latitude, location.longitude);
          });
        },
        onBackToList: () => setState(() => _isMapView = false),
        onApplyFilters: (timeOfDay, city, dist) {
          setState(() {
            _filterTimeOfDay = timeOfDay;
            _filterCity = city;
            _filterDistance = dist;
          });
        },
        onSportSelected: (sport) => setState(() {
          // <-- simple toggle, no null case
          if (_selectedSports.contains(sport)) {
            _selectedSports.remove(sport);
          } else {
            _selectedSports.add(sport);
          }
        }),
        selectedSports: _selectedSports,
      );
    }

    final grouped = _groupedMatches;

    return Scaffold(
      backgroundColor: kWhiteFo,
      appBar: CustomAppBar(
        title: "Open Matches",
        centerTile: false,
        backgroundColor: kWhiteColor,
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
                        hintStyle: AppStyles.w400f14inter,
                      ),
                    ),
                    8.widthBox,
                    GestureDetector(
                      onTap: () => MatchFilterBottomSheet.show(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: kBorderColor),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.svg.filterLines.path,
                            colorFilter: const ColorFilter.mode(
                              kDarkTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    8.widthBox,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isMapView = true;
                        });
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: kBorderColor),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.map_outlined,
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ).withPaddingSymmetric(16, 0),
                12.heightBox,
                CommonDateSelectionRow(
                  dates: _dates,
                  selectedDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
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
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: kBlackColor, shape: BoxShape.circle),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CreateMatchDialog(),
            );
          },
          child: Icon(Icons.add, color: kWhiteColor, size: 26),
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
