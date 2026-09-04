import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
import 'package:quadraclub_app/presentation/home/ui/court_detail_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_card_widget.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_map_view.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/search_courts_sheet.dart';

/// The 4 sport types the filter row always shows, regardless of what
/// happens to be present in the currently loaded clubs.
const List<String> kAllSportSlugs = [
  'padel',
  'tennis',
  'beach_tennis',
  'pickleball'
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMapView = false;
  String _currentLocation = 'London, UK';
  LatLng _currentLatLng = const LatLng(51.5072, -0.1276);

  final Set<String> _selectedSports = {};

  // Anchor is fixed once (today, at load time) so the 7-day strip doesn't
  // shift underneath the user; _selectedDate moves as they tap a day.
  late final DateTime _anchorDate;
  late DateTime _selectedDate;

  String _searchQuery = '';

  String? _filterTimeOfDay;
  String? _filterCity;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _anchorDate = DateTime(now.year, now.month, now.day);
    _selectedDate = _anchorDate;
  }

  List<DateTime> get _dates =>
      List.generate(7, (i) => _anchorDate.add(Duration(days: i)));

  String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Checks whether any court in [club] has an Available slot for
  /// _selectedDate that falls into the selected time-of-day bucket, for
  /// any of the currently-selected sports (or any sport if none selected).
  /// Only Tennis/Padel are individually addressable today because
  /// WeeklySlot.fromJson only decodes those two keys.
  bool _hasMatchingSlot(Club club) {
    final key = _dateKey(_selectedDate);
    final sportsToCheck = _selectedSports.isEmpty
        ? kAllSportSlugs.toSet()
        : _selectedSports;

    for (final court in club.courts) {
      final daySlots = court.weeklySlots[key];
      if (daySlots == null) continue;

      final List<Padel> slots = [
        if (sportsToCheck.contains('tennis')) ...daySlots.tennis,
        if (sportsToCheck.contains('padel')) ...daySlots.padel,
        if (sportsToCheck.contains('pickleball'))...daySlots.pickleball,
        if (sportsToCheck.contains('beach_tennis'))...daySlots.beachTennis,
      ];

      for (final slot in slots) {
        if (slot.status != 'Available') continue;
        final hour = int.tryParse((slot.startTime ?? '')
            .split(':')
            .first);
        if (hour == null) continue;

        if (_filterTimeOfDay == 'Morning' && hour >= 6 && hour < 12) {
          return true;
        }
        if (_filterTimeOfDay == 'Afternoon' && hour >= 12 && hour < 18) {
          return true;
        }
        if (_filterTimeOfDay == 'Night' && (hour >= 18 || hour < 6)) {
          return true;
        }
      }
    }
    return false;
  }

  List<Club> _filteredClubs(List<Club> clubs) {
    final query = _searchQuery.trim().toLowerCase();

    return clubs.where((club) {
      if (_selectedSports.isNotEmpty &&
          !club.sports.any(
                (s) => _selectedSports.contains(s.toLowerCase()),
          )) {
        return false;
      }

      if (query.isNotEmpty &&
          !(club.name ?? '').toLowerCase().contains(query) &&
          !(club.city ?? '').toLowerCase().contains(query)) {
        return false;
      }

      if (_filterCity != null &&
          (club.city ?? '').toLowerCase() != _filterCity!.toLowerCase()) {
        return false;
      }

      if (_filterTimeOfDay != null && !_hasMatchingSlot(club)) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourtsBloc, CourtsState>(
      builder: (context, state) {
        final clubsList = _filteredClubs(state.courts);

        if (_isMapView) {
          return CourtMapView(
            courts: clubsList,
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
              });
            },
            selectedSport: _selectedSports.isEmpty ? null : _selectedSports
                .first,
            onSportSelected: (sport) =>
                setState(() {
                  if (sport == null) {
                    _selectedSports.clear();
                  } else if (_selectedSports.contains(sport)) {
                    _selectedSports.remove(sport);
                  } else {
                    _selectedSports.add(sport);
                  }
                }),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: "Find courts near you.",
            centerTile: false,
            backgroundColor: kWhiteColor,
          ),
          body: state.status == CourtStateStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kAllSportSlugs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final sport = kAllSportSlugs[index];
                    final isSelected = _selectedSports.contains(sport);
                    final label = '${sport[0].toUpperCase()}${sport
                        .substring(1)
                        .replaceAll('_', ' ')}';
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedSports.remove(sport);
                          } else {
                            _selectedSports.add(sport);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? kPrimaryColor : kGreyColor,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? null
                              : Border.all(color: kBorderColor),
                        ),
                        child: Center(
                          child: Text(
                            label,
                            style: AppStyles.w400f14inter
                                .copyWith(color: kDarkTextColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              12.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          SearchCourtsSheet.show(
                            context,
                            courts: state.courts,
                            onCourtSelected: (club) {
                              setState(() {
                                _searchQuery = club.name ?? '';
                              });
                            },
                          );
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: kBorderColor),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.search,
                                  color: kDarkTextColor, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? _searchQuery
                                    : 'Search by name...',
                                style: AppStyles.w400f14inter
                                    .copyWith(color: kDarkTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    8.widthBox,
                    GestureDetector(
                      onTap: () {
                        CourtFilterBottomSheet.show(
                          context,
                          initialTimeOfDay: _filterTimeOfDay,
                          initialCity: _filterCity,
                          onApply: (timeOfDay, city, dist) {
                            setState(() {
                              _filterTimeOfDay = timeOfDay;
                              _filterCity = city;
                            });
                          },
                          initialDistance: 2.5,
                        );
                      },
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
                                kDarkTextColor, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                    8.widthBox,
                    GestureDetector(
                      onTap: () => setState(() => _isMapView = true),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: kBorderColor),
                        ),
                        child: const Center(
                          child: Icon(Icons.map_outlined,
                              color: kDarkTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              12.heightBox,
              CommonDateSelectionRow(
                dates: _dates,
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
              ),
              12.heightBox,
              Expanded(
                child: clubsList.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off_outlined,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No courts match your search/filters.',
                        style: AppStyles.w500f14inter
                            .copyWith(color: kTextColor),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _selectedSports.clear();
                            _filterTimeOfDay = null;
                            _filterCity = null;
                          });
                        },
                        child: const Text('Reset Filters'),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: clubsList.length,
                  padding: const EdgeInsets.only(bottom: 24),
                  itemBuilder: (context, index) {
                    return CourtCardWidget(
                      club: clubsList[index],
                      selectedDate: _selectedDate,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CourtDetailScreen(club: clubsList[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}